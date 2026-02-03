import 'package:community/app/themes/app_theme.dart';
import 'package:community/controllers/auth_controller.dart';
import 'package:community/controllers/comment_controller.dart';
import 'package:community/data/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskCommentsSection extends StatefulWidget {
  final int communityId;
  final int projectId;
  final int taskId;
  final String userRole;

  const TaskCommentsSection({
    super.key,
    required this.communityId,
    required this.projectId,
    required this.taskId,
    required this.userRole,
  });

  @override
  State<TaskCommentsSection> createState() => _TaskCommentsSectionState();
}

class _TaskCommentsSectionState extends State<TaskCommentsSection> {
  final CommentController _commentController = Get.find();
  final AuthController _authController = Get.find();

  final TextEditingController _commentInputController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentInputController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    await _commentController.loadTaskComments(
      communityId: widget.communityId,
      projectId: widget.projectId,
      taskId: widget.taskId,
    );
  }

  Future<void> _addComment() async {
    final content = _commentInputController.text.trim();
    if (content.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    final comment = await _commentController.addComment(
      communityId: widget.communityId,
      projectId: widget.projectId,
      taskId: widget.taskId,
      content: content,
    );

    setState(() => _isSending = false);

    if (comment != null) {
      _commentInputController.clear();
      _commentFocusNode.unfocus();
      Get.snackbar(
        'Succès',
        'Commentaire ajouté',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Erreur',
        'Impossible d\'ajouter le commentaire',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _editComment(CommentModel comment) {
    final TextEditingController editController = TextEditingController(
      text: comment.content,
    );

    Get.dialog(
      AlertDialog(
        title: const Text('Modifier le commentaire'),
        content: TextField(
          controller: editController,
          maxLines: 4,
          minLines: 3,
          decoration: const InputDecoration(
            hintText: 'Modifiez votre commentaire...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              final newContent = editController.text.trim();
              if (newContent.isEmpty) return;

              Get.back();

              final success = await _commentController.updateComment(
                communityId: widget.communityId,
                projectId: widget.projectId,
                taskId: widget.taskId,
                commentId: comment.id,
                content: newContent,
              );

              if (success) {
                Get.snackbar(
                  'Succès',
                  'Commentaire modifié',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else {
                Get.snackbar(
                  'Erreur',
                  'Impossible de modifier',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  void _deleteComment(CommentModel comment) {
    Get.dialog(
      AlertDialog(
        title: const Text('Supprimer le commentaire'),
        content: const Text(
          'Êtes-vous sûr de vouloir supprimer ce commentaire ?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              Get.back();

              final success = await _commentController.deleteComment(
                communityId: widget.communityId,
                projectId: widget.projectId,
                taskId: widget.taskId,
                commentId: comment.id,
              );

              if (success) {
                Get.snackbar(
                  'Succès',
                  'Commentaire supprimé',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else {
                Get.snackbar(
                  'Erreur',
                  'Impossible de supprimer',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Row(
            children: [
              Text(
                'Commentaires',
                style: AppTheme.headline2.copyWith(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_commentController.comments.length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: _loadComments,
                tooltip: 'Actualiser',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Champ de saisie en haut
          _buildCommentInput(),
          const SizedBox(height: 16),

          // Liste des commentaires
          Obx(() {
            if (_commentController.isLoading.value &&
                _commentController.comments.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (_commentController.comments.isEmpty) {
              return _buildEmptyState();
            }

            return Column(
              children: _commentController.comments
                  .map((comment) => _buildCommentCard(comment))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _commentInputController,
              focusNode: _commentFocusNode,
              maxLines: 3,
              minLines: 1,
              decoration: const InputDecoration(
                hintText: 'Ajouter un commentaire...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _addComment(),
            ),
          ),
          const SizedBox(width: 8),
          _isSending
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _addComment,
                  tooltip: 'Envoyer',
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'Aucun commentaire',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Soyez le premier à commenter !',
            style: TextStyle(color: Colors.grey[500], fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(CommentModel comment) {
    final currentUserEmail = _authController.user.value?.email ?? '';
    final canEdit = comment.email == currentUserEmail;
    final canDelete =
        widget.userRole == 'ADMIN' ||
        widget.userRole == 'RESPONSABLE' ||
        comment.email == currentUserEmail;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: _getUserColor(comment.email),
                child: Text(
                  _getUserInitials(comment.fullName),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.fullName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatDate(comment.created_at),
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              if (canEdit || canDelete)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) => [
                    if (canEdit)
                      const PopupMenuItem(
                        value: 'edit',
                        height: 40,
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 16),
                            SizedBox(width: 8),
                            Text('Modifier', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                    if (canDelete)
                      const PopupMenuItem(
                        value: 'delete',
                        height: 40,
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 16, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Supprimer',
                              style: TextStyle(fontSize: 13, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') _editComment(comment);
                    if (value == 'delete') _deleteComment(comment);
                  },
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Content
          Text(
            comment.content,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),

          // Updated indicator
          if (comment.updated_at != null) ...[
            const SizedBox(height: 8),
            Text(
              'Modifié ${_formatDate(comment.updated_at!)}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getUserColor(String email) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
    ];
    return colors[email.hashCode.abs() % colors.length];
  }

  String _getUserInitials(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    if (diff.inDays == 1) return 'Hier';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays} jours';
    return '${date.day}/${date.month}/${date.year}';
  }
}
