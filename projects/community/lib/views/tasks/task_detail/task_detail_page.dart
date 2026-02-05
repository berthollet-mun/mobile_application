import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:community/controllers/community_controller.dart';
import 'package:community/controllers/project_controller.dart';
import 'package:community/controllers/task_controller.dart';
import 'package:community/app/routes/app_routes.dart';
import 'package:community/app/themes/app_theme.dart';
import 'package:community/data/models/task_model.dart';
import 'package:community/views/shared/widgets/loading_widget.dart';
import 'package:community/views/shared/widgets/status_chip.dart';

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({super.key});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TaskController _taskController = Get.find();
  final ProjectController _projectController = Get.find();
  final CommunityController _communityController = Get.find();

  late int _communityId;
  late int _projectId;
  late int _taskId;

  @override
  void initState() {
    super.initState();
    final task = _taskController.currentTask.value;
    final project = _projectController.currentProject.value;
    final community = _communityController.currentCommunity.value;

    if (task != null && project != null && community != null) {
      _taskId = task.id;
      _projectId = project.id;
      _communityId = community.community_id;
      _loadData();
    }
  }

  Future<void> _loadData() async {
    await _taskController.loadTaskDetails(
      communityId: _communityId,
      projectId: _projectId,
      taskId: _taskId,
    );
  }

  void _changeStatus(String newStatus) async {
    final success = await _taskController.updateTaskStatus(
      communityId: _communityId,
      projectId: _projectId,
      taskId: _taskId,
      status: newStatus,
    );
    if (success) {
      Get.snackbar(
        'Succès',
        'Statut: "$newStatus"',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final community = _communityController.currentCommunity.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.toNamed(AppRoutes.createEditTask),
          ),
        ],
      ),
      body: Obx(() {
        if (_taskController.isLoading.value) {
          return const LoadingWidget(message: 'Chargement...');
        }

        final task = _taskController.currentTask.value;
        if (task == null || community == null) {
          return const Center(child: Text('Tâche non trouvée'));
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(task),
                const SizedBox(height: 24),
                _buildDetails(task, community),
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildDescription(task),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(TaskModel task) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
        border: task.isOverdue ? Border.all(color: Colors.red, width: 2) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.titre,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              StatusChip(status: task.status),
            ],
          ),
          if (task.isOverdue) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning, color: Colors.red, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'En retard !',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetails(TaskModel task, dynamic community) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations',
            style: AppTheme.headline2.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),

          _buildInfoRow(
            Icons.person_outline,
            'Assigné à',
            task.assignedFullName,
          ),
          const Divider(height: 24),

          _buildInfoRow(
            Icons.calendar_today,
            'Échéance',
            task.due_date != null ? _formatDate(task.due_date!) : 'Non définie',
            color: task.isOverdue ? Colors.red : null,
          ),
          const Divider(height: 24),

          _buildInfoRow(
            Icons.folder_outlined,
            'Projet',
            task.project_nom ?? 'N/A',
          ),
          const Divider(height: 24),

          _buildInfoRow(
            Icons.person_add_outlined,
            'Créé par',
            task.creatorFullName,
          ),
          const Divider(height: 24),

          _buildInfoRow(
            Icons.access_time,
            'Créée le',
            _formatDateTime(task.created_at),
          ),
          const Divider(height: 24),

          // _buildInfoRow(
          //   Icons.comment_outlined,
          //   'Commentaires',
          //   '${task.comments_count}',
          // ),
          _buildCommentRow(task),

          const SizedBox(height: 20),

          // Status buttons
          if (community.role != 'MEMBRE') ...[
            Text('Changer statut', style: AppTheme.bodyText2),
            const SizedBox(height: 8),
            Row(
              children: ['À faire', 'En cours', 'Terminé'].map((status) {
                final isSelected = task.status == status;
                final color = _getStatusColor(status);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: isSelected
                          ? null
                          : () => _changeStatus(status),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? color
                            : color.withOpacity(0.1),
                        foregroundColor: isSelected ? Colors.white : color,
                        elevation: 0,
                      ),
                      child: Text(status, style: const TextStyle(fontSize: 11)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey[600]),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: Colors.grey[600])),
        const Spacer(),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }

  Widget _buildDescription(TaskModel task) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Description', style: AppTheme.headline2.copyWith(fontSize: 18)),
          const SizedBox(height: 12),
          Text(task.description, style: const TextStyle(height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildCommentRow(TaskModel task) {
    final community = _communityController.currentCommunity.value;

    return InkWell(
      onTap: () {
        Get.toNamed(
          AppRoutes.taskComments,
          arguments: {
            'communityId': _communityId,
            'projectId': _projectId,
            'taskId': _taskId,
            'taskTitle': task.titre,
            'userRole': community?.role ?? 'MEMBRE',
          },
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(Icons.chat_bubble_outline, size: 20, color: Colors.blue[600]),
            const SizedBox(width: 12),
            Text('Commentaires', style: TextStyle(color: Colors.grey[600])),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${task.comments_count}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'À faire':
        return Colors.grey;
      case 'En cours':
        return Colors.orange;
      case 'Terminé':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
