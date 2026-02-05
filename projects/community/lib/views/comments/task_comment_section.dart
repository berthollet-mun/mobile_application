import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:community/controllers/comment_controller.dart';
import 'package:community/controllers/auth_controller.dart';
import 'package:community/core/services/comment_service.dart';
import 'package:community/data/models/comment_model.dart';

class TaskCommentsPage extends StatefulWidget {
  const TaskCommentsPage({super.key});

  @override
  State<TaskCommentsPage> createState() => _TaskCommentsPageState();
}

class _TaskCommentsPageState extends State<TaskCommentsPage> {
  late final CommentController _commentController;
  final AuthController _authController = Get.find();

  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late int _communityId;
  late int _projectId;
  late int _taskId;
  late String _taskTitle;
  late String _userRole;

  bool _isSending = false;

  @override
  void initState() {
    super.initState();

    // Récupérer les arguments
    final args = Get.arguments as Map<String, dynamic>;
    _communityId = args['communityId'];
    _projectId = args['projectId'];
    _taskId = args['taskId'];
    _taskTitle = args['taskTitle'] ?? 'Tâche';
    _userRole = args['userRole'] ?? 'MEMBRE';

    // Initialiser les controllers
    if (!Get.isRegistered<CommentService>()) {
      Get.put(CommentService());
    }
    if (!Get.isRegistered<CommentController>()) {
      Get.put(CommentController());
    }
    _commentController = Get.find<CommentController>();

    _loadComments();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    await _commentController.loadTaskComments(
      communityId: _communityId,
      projectId: _projectId,
      taskId: _taskId,
    );
  }

  Future<void> _sendComment() async {
    final content = _inputController.text.trim();
    if (content.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    final comment = await _commentController.addComment(
      communityId: _communityId,
      projectId: _projectId,
      taskId: _taskId,
      content: content,
    );

    setState(() => _isSending = false);

    if (comment != null) {
      _inputController.clear();
      _focusNode.unfocus();
      Get.snackbar(
        'Succès',
        'Commentaire ajouté',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Erreur',
        'Impossible d\'ajouter le commentaire',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _editComment(CommentModel comment) {
    final editController = TextEditingController(text: comment.content);

    Get.dialog(
      AlertDialog(
        title: const Text('Modifier le commentaire'),
        content: TextField(
          controller: editController,
          maxLines: 5,
          minLines: 3,
          decoration: const InputDecoration(
            hintText: 'Votre commentaire...',
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
                communityId: _communityId,
                projectId: _projectId,
                taskId: _taskId,
                commentId: comment.id,
                content: newContent,
              );

              Get.snackbar(
                success ? 'Succès' : 'Erreur',
                success ? 'Commentaire modifié' : 'Échec de la modification',
                backgroundColor: success ? Colors.green : Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
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
        title: const Text('Supprimer'),
        content: const Text('Voulez-vous vraiment supprimer ce commentaire ?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              Get.back();

              final success = await _commentController.deleteComment(
                communityId: _communityId,
                projectId: _projectId,
                taskId: _taskId,
                commentId: comment.id,
              );

              Get.snackbar(
                success ? 'Succès' : 'Erreur',
                success ? 'Commentaire supprimé' : 'Échec de la suppression',
                backgroundColor: success ? Colors.green : Colors.red,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
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
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Commentaires', style: TextStyle(fontSize: 18)),
            Text(
              _taskTitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadComments),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (_commentController.isLoading.value &&
                  _commentController.comments.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_commentController.comments.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: _loadComments,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _commentController.comments.length,
                  itemBuilder: (context, index) {
                    return _buildCommentCard(
                      _commentController.comments[index],
                    );
                  },
                ),
              );
            }),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Aucun commentaire',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Soyez le premier à commenter !',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(CommentModel comment) {
    final currentUserEmail = _authController.user.value?.email ?? '';
    final isMyComment = comment.email == currentUserEmail;
    final canDelete =
        _userRole == 'ADMIN' || _userRole == 'RESPONSABLE' || isMyComment;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isMyComment ? Colors.blue.withOpacity(0.05) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMyComment ? Colors.blue.withOpacity(0.2) : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: _getAvatarColor(comment.email),
                child: Text(
                  _getInitials(comment.fullName),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            comment.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isMyComment) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Vous',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      _formatDate(comment.created_at),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              if (isMyComment || canDelete)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  itemBuilder: (context) => [
                    if (isMyComment)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Modifier'),
                          ],
                        ),
                      ),
                    if (canDelete)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Supprimer',
                              style: TextStyle(color: Colors.red),
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
          const SizedBox(height: 12),
          Text(
            comment.content,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
          if (comment.updated_at != null) ...[
            const SizedBox(height: 8),
            Text(
              '(modifié ${_formatDate(comment.updated_at!)})',
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

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _inputController,
                  focusNode: _focusNode,
                  maxLines: 4,
                  minLines: 1,
                  decoration: const InputDecoration(
                    hintText: 'Écrire un commentaire...',
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendComment(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _isSending
                ? const SizedBox(
                    width: 48,
                    height: 48,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendComment,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Color _getAvatarColor(String email) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[email.hashCode.abs() % colors.length];
  }

  String _getInitials(String fullName) {
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
