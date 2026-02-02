import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:community/controllers/community_controller.dart';
import 'package:community/controllers/project_controller.dart';
import 'package:community/app/routes/app_routes.dart';
import 'package:community/app/themes/app_theme.dart';
import 'package:community/data/models/community_model.dart';
import 'package:community/data/models/project_model.dart';
import 'package:community/views/shared/widgets/empty_state.dart';
import 'package:community/views/shared/widgets/loading_widget.dart';

class ProjectsListPage extends StatefulWidget {
  const ProjectsListPage({super.key});

  @override
  State<ProjectsListPage> createState() => _ProjectsListPageState();
}

class _ProjectsListPageState extends State<ProjectsListPage> {
  final ProjectController _projectController = Get.find();
  final CommunityController _communityController = Get.find();

  late int _communityId;

  @override
  void initState() {
    super.initState();
    final community = _communityController.currentCommunity.value;
    if (community != null) {
      _communityId = community.community_id;
      _loadProjects();
    }
  }

  Future<void> _loadProjects() async {
    await _projectController.loadProjects(_communityId);
  }

  @override
  Widget build(BuildContext context) {
    final community = _communityController.currentCommunity.value;
    if (community == null) {
      return const Scaffold(
        body: Center(child: Text('Communauté non sélectionnée')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Projets - ${community.nom}'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadProjects),
          if (_canCreateProject(community))
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Get.toNamed(AppRoutes.createEditProject),
            ),
        ],
      ),
      body: Obx(() {
        if (_projectController.isLoading.value) {
          return const LoadingWidget(message: 'Chargement des projets...');
        }

        if (_projectController.error.value.isNotEmpty) {
          return EmptyStateWidget(
            title: 'Erreur',
            message: _projectController.error.value,
            icon: Icons.error_outline,
            onAction: _loadProjects,
            actionLabel: 'Réessayer',
          );
        }

        final projects = _projectController.activeProjects;

        if (projects.isEmpty) {
          return EmptyStateWidget(
            title: 'Aucun projet',
            message: 'Créez votre premier projet !',
            icon: Icons.folder_open_outlined,
            onAction: () => Get.toNamed(AppRoutes.createEditProject),
            actionLabel: 'Créer un projet',
          );
        }

        return RefreshIndicator(
          onRefresh: _loadProjects,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            itemBuilder: (context, index) =>
                _buildProjectCard(projects[index], community),
          ),
        );
      }),
      floatingActionButton: _canCreateProject(community)
          ? FloatingActionButton.extended(
              onPressed: () => Get.toNamed(AppRoutes.createEditProject),
              icon: const Icon(Icons.add),
              label: const Text('Nouveau projet'),
            )
          : null,
    );
  }

  Widget _buildProjectCard(ProjectModel project, CommunityModel community) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _projectController.setCurrentProject(project);
          Get.toNamed(AppRoutes.kanbanBoard);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.folder_outlined,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.nom,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (project.description.isNotEmpty)
                          Text(
                            project.description,
                            style: AppTheme.bodyText2,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStat(
                    Icons.task_outlined,
                    '${project.tasks_count}',
                    'Tâches',
                  ),
                  _buildStat(
                    Icons.check_circle_outline,
                    '${project.completion_percentage.toStringAsFixed(0)}%',
                    'Terminé',
                  ),
                  _buildStat(
                    Icons.calendar_today,
                    _formatDate(project.created_at),
                    'Créé',
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress bar
              LinearProgressIndicator(
                value: project.completion_percentage / 100,
                backgroundColor: Colors.grey[200],
                color: _getProgressColor(project.completion_percentage),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        Text(label, style: AppTheme.bodyText2.copyWith(fontSize: 11)),
      ],
    );
  }

  bool _canCreateProject(CommunityModel community) {
    return community.role == 'ADMIN' || community.role == 'RESPONSABLE';
  }

  Color _getProgressColor(double percentage) {
    if (percentage < 30) return Colors.red;
    if (percentage < 70) return Colors.orange;
    return Colors.green;
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return "Aujourd'hui";
    if (diff == 1) return 'Hier';
    if (diff < 7) return 'Il y a $diff jours';
    return '${date.day}/${date.month}';
  }
}
