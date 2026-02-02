import 'package:community/app/routes/app_routes.dart';
import 'package:community/app/themes/app_theme.dart';
import 'package:community/controllers/community_controller.dart';
import 'package:community/controllers/project_controller.dart';
import 'package:community/data/models/community_model.dart';
import 'package:community/views/shared/widgets/button.dart';
import 'package:community/views/shared/widgets/loading_widget.dart';
import 'package:community/views/shared/widgets/role_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunityDashboardPage extends StatefulWidget {
  const CommunityDashboardPage({super.key});

  @override
  State<CommunityDashboardPage> createState() => _CommunityDashboardPageState();
}

class _CommunityDashboardPageState extends State<CommunityDashboardPage> {
  final CommunityController _communityController = Get.find();
  final ProjectController _projectController = Get.find();

  late CommunityModel _community;

  @override
  void initState() {
    super.initState();
    _community = _communityController.currentCommunity.value!;
    _loadData();
  }

  Future<void> _loadData() async {
    await _projectController.loadProjects(_community.community_id);
    await _communityController.refreshCurrentCommunity();
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final community = _communityController.currentCommunity.value;
          return Text(community?.nom ?? 'Tableau de bord');
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Actualiser',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showOptions,
            tooltip: 'Options',
          ),
        ],
      ),
      body: Obx(() {
        final community = _communityController.currentCommunity.value;
        if (community == null) {
          return const Center(child: Text('Communauté non trouvée'));
        }

        if (_projectController.isLoading.value) {
          return const LoadingWidget(message: 'Chargement des données...');
        }

        return RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // En-tête de la communauté
              _buildCommunityHeader(community),
              const SizedBox(height: 24),
              // Statistiques
              _buildStatisticsSection(community),
              const SizedBox(height: 24),
              // Navigation rapide
              _buildQuickActions(community),
              const SizedBox(height: 24),
              // Projets récents
              _buildRecentProjects(community),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed(AppRoutes.createEditProject);
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouveau projet'),
        heroTag: 'new_project',
      ),
    );
  }

  Widget _buildCommunityHeader(CommunityModel community) {
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
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getCommunityColor(community.community_id),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    community.nom.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            community.nom,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        RoleBadge(role: community.role),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (community.description.isNotEmpty)
                      Text(community.description, style: AppTheme.bodyText2),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Code d\'invitation',
                    style: AppTheme.bodyText2.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    community.invite_code.toString(),
                    style: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  _copyInviteCode(community);
                },
                icon: const Icon(Icons.content_copy),
                tooltip: 'Copier le code',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(CommunityModel community) {
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
            'Statistiques',
            style: AppTheme.headline2.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                context,
                icon: Icons.people_outline,
                value: community.members_count.toString(),
                label: 'Membres',
                color: Colors.blue,
              ),
              _buildStatCard(
                context,
                icon: Icons.folder_outlined,
                value: community.projects_count?.toString() ?? '0',
                label: 'Projets',
                color: Colors.green,
              ),
              _buildStatCard(
                context,
                icon: Icons.task_outlined,
                value: '0', // À remplacer avec les vraies données
                label: 'Tâches',
                color: Colors.orange,
              ),
              _buildStatCard(
                context,
                icon: Icons.check_circle_outline,
                value: '0%', // À remplacer avec les vraies données
                label: 'Achevées',
                color: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTheme.bodyText2),
        ],
      ),
    );
  }

  Widget _buildQuickActions(CommunityModel community) {
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
            'Navigation rapide',
            style: AppTheme.headline2.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
            children: [
              _buildQuickActionButton(
                context,
                icon: Icons.folder_open,
                label: 'Projets',
                onTap: () {
                  Get.toNamed(AppRoutes.projectsList);
                },
                color: Colors.blue,
              ),
              _buildQuickActionButton(
                context,
                icon: Icons.people,
                label: 'Membres',
                onTap: () {
                  Get.toNamed(AppRoutes.membersList);
                },
                color: Colors.green,
                enabled: community.role == 'ADMIN',
              ),
              _buildQuickActionButton(
                context,
                icon: Icons.history,
                label: 'Historique',
                onTap: () {
                  Get.toNamed(AppRoutes.activityLog);
                },
                color: Colors.orange,
              ),
              _buildQuickActionButton(
                context,
                icon: Icons.person_add,
                label: 'Inviter',
                onTap: () {
                  Get.toNamed(AppRoutes.inviteMember);
                },
                color: Colors.purple,
                enabled: community.role == 'ADMIN',
              ),
              _buildQuickActionButton(
                context,
                icon: Icons.settings,
                label: 'Paramètres',
                onTap: () {
                  _showSettings(community);
                },
                color: Colors.teal,
                enabled: community.role == 'ADMIN',
              ),
              _buildQuickActionButton(
                context,
                icon: Icons.help_outline,
                label: 'Aide',
                onTap: () {
                  _showHelp();
                },
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    bool enabled = true,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: enabled ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: enabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: enabled ? color : Colors.grey),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: enabled ? color : Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentProjects(CommunityModel community) {
    final projects = _projectController.activeProjects.take(3).toList();

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
          Row(
            children: [
              Expanded(
                child: Text(
                  'Projets récents',
                  style: AppTheme.headline2.copyWith(fontSize: 20),
                ),
              ),
              if (_projectController.activeProjects.isNotEmpty)
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.projectsList);
                  },
                  child: const Text('Voir tout'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (projects.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(
                    Icons.folder_open_outlined,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Aucun projet pour le moment',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  SecondaryButton(
                    text: 'Créer un premier projet',
                    onPressed: () {
                      Get.toNamed(AppRoutes.createEditProject);
                    },
                    fullWidth: false,
                  ),
                ],
              ),
            )
          else
            Column(
              children: projects.map((project) {
                return _buildProjectItem(project);
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildProjectItem(dynamic project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ListTile(
        leading: const Icon(Icons.folder_outlined, color: Colors.blue),
        title: Text(project.nom),
        subtitle: Text(
          project.description.isNotEmpty
              ? project.description
              : 'Aucune description',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          _projectController.setCurrentProject(project);
          Get.toNamed(AppRoutes.kanbanBoard);
        },
      ),
    );
  }

  void _showOptions() {
    final community = _communityController.currentCommunity.value;
    if (community == null) return;

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
              leading: const Icon(Icons.refresh),
              title: const Text('Actualiser'),
              onTap: () {
                Get.back();
                _refreshData();
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Détails de la communauté'),
              onTap: () {
                Get.back();
                _showCommunityDetails(community);
              },
            ),
            if (community.role == 'ADMIN') ...[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Modifier la communauté'),
                onTap: () {
                  Get.back();
                  _editCommunity(community);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Supprimer la communauté',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Get.back();
                  _confirmDeleteCommunity(community);
                },
              ),
            ],
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Quitter cette communauté'),
              onTap: () {
                Get.back();
                _confirmLeaveCommunity(community);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCommunityDetails(CommunityModel community) {
    Get.dialog(
      AlertDialog(
        title: const Text('Détails de la communauté'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nom: ${community.nom}'),
            const SizedBox(height: 8),
            Text(
              'Description: ${community.description.isNotEmpty ? community.description : "Aucune"}',
            ),
            const SizedBox(height: 8),
            Text('Code d\'invitation: ${community.invite_code}'),
            const SizedBox(height: 8),
            Text('Votre rôle: ${community.role}'),
            const SizedBox(height: 8),
            Text('Membres: ${community.members_count}'),
            const SizedBox(height: 8),
            Text('Projets: ${community.projects_count}'),
            const SizedBox(height: 8),
            // ✅ APRÈS
            Text(
              'Créée le: ${community.created_at != null ? _formatDate(community.created_at!) : 'N/A'}',
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
        ],
      ),
    );
  }

  void _editCommunity(CommunityModel community) {
    Get.snackbar(
      'Fonctionnalité à venir',
      'L\'édition de communauté sera disponible bientôt.',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void _confirmDeleteCommunity(CommunityModel community) {
    Get.dialog(
      AlertDialog(
        title: const Text('Supprimer la communauté'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer définitivement la communauté "${community.nom}" ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              Get.back();
              _deleteCommunity(community);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _deleteCommunity(CommunityModel community) {
    Get.snackbar(
      'Fonctionnalité à venir',
      'La suppression de communauté sera disponible bientôt.',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void _confirmLeaveCommunity(CommunityModel community) {
    Get.dialog(
      AlertDialog(
        title: const Text('Quitter la communauté'),
        content: Text(
          'Êtes-vous sûr de vouloir quitter la communauté "${community.nom}" ?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              Get.back();
              _leaveCommunity(community);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Quitter'),
          ),
        ],
      ),
    );
  }

  void _leaveCommunity(CommunityModel community) {
    Get.snackbar(
      'Fonctionnalité à venir',
      'La fonction de quitter une communauté sera disponible bientôt.',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void _copyInviteCode(CommunityModel community) {
    // clipboard.setData(ClipboardData(text: community.inviteCode));
    Get.snackbar(
      'Code copié',
      'Le code d\'invitation a été copié dans le presse-papier.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _showSettings(CommunityModel community) {
    Get.snackbar(
      'Paramètres',
      'Les paramètres avancés de communauté seront disponibles bientôt.',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _showHelp() {
    Get.defaultDialog(
      title: 'Aide - Tableau de bord',
      content: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Le tableau de bord vous permet de :'),
          SizedBox(height: 8),
          Text('• Voir les statistiques de votre communauté'),
          Text('• Accéder rapidement aux différentes sections'),
          Text('• Voir les projets récents'),
          Text('• Gérer les paramètres (Admin uniquement)'),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
      ],
    );
  }

  Color _getCommunityColor(int id) {
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
    return colors[id % colors.length];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
