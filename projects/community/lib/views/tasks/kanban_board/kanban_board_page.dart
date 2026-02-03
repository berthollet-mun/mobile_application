import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:community/controllers/community_controller.dart';
import 'package:community/controllers/project_controller.dart';
import 'package:community/controllers/task_controller.dart';
import 'package:community/app/routes/app_routes.dart';
import 'package:community/app/themes/app_theme.dart';
import 'package:community/data/models/community_model.dart';
import 'package:community/data/models/task_model.dart';
import 'package:community/views/shared/widgets/empty_state.dart';
import 'package:community/views/shared/widgets/loading_widget.dart';

class KanbanBoardPage extends StatefulWidget {
  const KanbanBoardPage({super.key});

  @override
  State<KanbanBoardPage> createState() => _KanbanBoardPageState();
}

class _KanbanBoardPageState extends State<KanbanBoardPage> {
  final TaskController _taskController = Get.find();
  final ProjectController _projectController = Get.find();
  final CommunityController _communityController = Get.find();

  late int _communityId;
  late int _projectId;

  @override
  void initState() {
    super.initState();
    final project = _projectController.currentProject.value;
    final community = _communityController.currentCommunity.value;

    if (project != null && community != null) {
      _projectId = project.id;
      _communityId = community.community_id;
      _loadKanban();
    }
  }

  Future<void> _loadKanban() async {
    await _taskController.loadKanbanTasks(
      communityId: _communityId,
      projectId: _projectId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final project = _projectController.currentProject.value;
    final community = _communityController.currentCommunity.value;

    if (project == null || community == null) {
      return const Scaffold(
        body: Center(child: Text('Projet non sélectionné')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.nom, style: const TextStyle(fontSize: 16)),
            Text(
              'Tableau Kanban',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadKanban),
        ],
      ),
      body: Obx(() {
        if (_taskController.isLoading.value) {
          return const LoadingWidget(message: 'Chargement...');
        }

        if (_taskController.error.value.isNotEmpty) {
          return EmptyStateWidget(
            title: 'Erreur',
            message: _taskController.error.value,
            icon: Icons.error_outline,
            onAction: _loadKanban,
            actionLabel: 'Réessayer',
          );
        }

        final kanban = _taskController.kanban.value;
        if (kanban == null || kanban.totalTasks == 0) {
          return EmptyStateWidget(
            title: 'Tableau vide',
            message: 'Créez votre première tâche !',
            icon: Icons.view_kanban_outlined,
            onAction: () => Get.toNamed(AppRoutes.createEditTask),
            actionLabel: 'Créer une tâche',
          );
        }

        return RefreshIndicator(
          onRefresh: _loadKanban,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildColumn(
                  'À faire',
                  kanban.todo,
                  Colors.red,
                  Icons.pending_actions,
                ),
                const SizedBox(width: 16),
                _buildColumn(
                  'En cours',
                  kanban.inProgress,
                  Colors.orange,
                  Icons.autorenew,
                ),
                const SizedBox(width: 16),
                _buildColumn(
                  'Terminé',
                  kanban.done,
                  Colors.green,
                  Icons.check_circle_outline,
                ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: _canCreateTask(community)
          ? FloatingActionButton.extended(
              onPressed: () => Get.toNamed(AppRoutes.createEditTask),
              icon: const Icon(Icons.add),
              label: const Text('Nouvelle tâche'),
            )
          : null,
      bottomNavigationBar: _buildProgressBar(),
    );
  }

  Widget _buildProgressBar() {
    return Obx(() {
      final kanban = _taskController.kanban.value;
      final total = kanban?.totalTasks ?? 0;
      final completed = kanban?.done.length ?? 0;
      final percentage = total > 0 ? (completed / total * 100) : 0.0;

      return Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).cardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Progression', style: AppTheme.bodyText2),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Tâches', style: AppTheme.bodyText2),
                Text(
                  '$completed/$total',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildColumn(
    String title,
    List<TaskModel> tasks,
    Color color,
    IconData icon,
  ) {
    final community = _communityController.currentCommunity.value!;

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600, color: color),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${tasks.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tasks
          if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    'Aucune tâche',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          else
            ...tasks.map((task) => _buildTaskCard(task, community)),

          // Add button
          if (title == 'À faire' && _canCreateTask(community))
            Container(
              padding: const EdgeInsets.all(12),
              child: TextButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.createEditTask),
                icon: Icon(Icons.add, color: color, size: 18),
                label: Text('Ajouter', style: TextStyle(color: color)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task, CommunityModel community) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
        ],
        border: task.isOverdue ? Border.all(color: Colors.red, width: 2) : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _taskController.setCurrentTask(task);
          Get.toNamed(AppRoutes.taskDetail);
        },
        onLongPress: () => _showTaskOptions(task, community),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.titre,
                style: const TextStyle(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: AppTheme.bodyText2.copyWith(fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  if (task.isAssigned)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        task.assigned_prenom ?? 'Assigné',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  const Spacer(),
                  if (task.due_date != null) ...[
                    Icon(
                      Icons.calendar_today,
                      size: 12,
                      color: task.isOverdue ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(task.due_date!),
                      style: TextStyle(
                        fontSize: 10,
                        color: task.isOverdue ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTaskOptions(TaskModel task, CommunityModel community) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('Voir'),
              onTap: () {
                Get.back();
                _taskController.setCurrentTask(task);
                Get.toNamed(AppRoutes.taskDetail);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Modifier'),
              onTap: () {
                Get.back();
                _taskController.setCurrentTask(task);
                Get.toNamed(AppRoutes.createEditTask);
              },
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('Changer statut'),
              onTap: () {
                Get.back();
                _showStatusDialog(task);
              },
            ),
            if (community.role == 'ADMIN') ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Supprimer',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Get.back();
                  _confirmDelete(task);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showStatusDialog(TaskModel task) {
    Get.dialog(
      AlertDialog(
        title: const Text('Changer statut'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['À faire', 'En cours', 'Terminé'].map((status) {
            return ListTile(
              leading: Icon(
                status == task.status
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: status == task.status ? Colors.blue : Colors.grey,
              ),
              title: Text(status),
              onTap: status == task.status
                  ? null
                  : () async {
                      Get.back();
                      await _taskController.updateTaskStatus(
                        communityId: _communityId,
                        projectId: _projectId,
                        taskId: task.id,
                        status: status,
                      );
                    },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _confirmDelete(TaskModel task) {
    Get.dialog(
      AlertDialog(
        title: const Text('Supprimer'),
        content: Text('Supprimer "${task.titre}" ?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              Get.back();
              await _taskController.deleteTask(
                communityId: _communityId,
                projectId: _projectId,
                taskId: task.id,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  bool _canCreateTask(CommunityModel community) {
    return community.role == 'ADMIN' || community.role == 'RESPONSABLE';
  }

  String _formatDate(DateTime date) {
    final diff = date.difference(DateTime.now()).inDays;
    if (diff == 0) return "Aujourd'hui";
    if (diff == 1) return 'Demain';
    if (diff == -1) return 'Hier';
    return '${date.day}/${date.month}';
  }
}
