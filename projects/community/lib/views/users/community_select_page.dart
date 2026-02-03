import 'package:community/app/routes/app_routes.dart';
import 'package:community/app/themes/app_theme.dart';
import 'package:community/controllers/auth_controller.dart';
import 'package:community/controllers/community_controller.dart';
import 'package:community/data/models/community_model.dart';
import 'package:community/views/shared/widgets/button.dart';
import 'package:community/views/shared/widgets/empty_state.dart';
import 'package:community/views/shared/widgets/loading_widget.dart';
import 'package:community/views/shared/widgets/role_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommunitySelectPage extends StatefulWidget {
  const CommunitySelectPage({super.key});

  @override
  State<CommunitySelectPage> createState() => _CommunitySelectPageState();
}

class _CommunitySelectPageState extends State<CommunitySelectPage> {
  final CommunityController _communityController = Get.find();
  final AuthController _authController = Get.find();

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  Future<void> _loadCommunities() async {
    await _communityController.loadCommunities();
  }

  Future<void> _refreshCommunities() async {
    await _loadCommunities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Communautés'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCommunities,
            tooltip: 'Actualiser',
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Get.toNamed(AppRoutes.profile);
            },
            tooltip: 'Profil',
          ),
        ],
      ),
      body: Obx(() {
        if (_communityController.isLoading.value) {
          return const LoadingWidget(
            message: 'Chargement de vos communautés...',
          );
        }

        if (_communityController.error.value.isNotEmpty) {
          return EmptyStateWidget(
            title: 'Erreur de chargement',
            message: _communityController.error.value,
            icon: Icons.error_outline,
            onAction: _refreshCommunities,
            actionLabel: 'Réessayer',
          );
        }

        if (_communityController.communities.isEmpty) {
          return EmptyStateWidget(
            title: 'Aucune communauté',
            message:
                'Vous n\'êtes pas encore membre d\'une communauté. Créez-en une ou rejoignez-en une !',
            icon: Icons.groups_outlined,
            onAction: () {
              Get.toNamed(AppRoutes.createCommunity);
            },
            actionLabel: 'Créer une communauté',
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshCommunities,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // En-tête
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour, ${_authController.user.value?.prenom ?? 'Utilisateur'} !',
                      style: AppTheme.headline2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sélectionnez une communauté pour commencer',
                      style: AppTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              // Liste des communautés
              ..._communityController.communities.map((community) {
                return _buildCommunityCard(community);
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              Get.toNamed(AppRoutes.joinCommunity);
            },
            icon: const Icon(Icons.key),
            label: const Text('Rejoindre'),
            heroTag: 'join_community',
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            onPressed: () {
              Get.toNamed(AppRoutes.createCommunity);
            },
            icon: const Icon(Icons.add),
            label: const Text('Créer'),
            heroTag: 'create_community',
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).cardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_communityController.communities.length} communauté(s)',
              style: AppTheme.bodyText2,
            ),
            TextButton(
              onPressed: () {
                Get.defaultDialog(
                  title: 'À propos des communautés',
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Les communautés sont des espaces de travail collaboratifs où vous pouvez :',
                      ),
                      SizedBox(height: 8),
                      Text('• Créer et gérer des projets'),
                      Text('• Travailler avec d\'autres membres'),
                      Text('• Suivre l\'avancement des tâches'),
                      Text('• Communiquer en temps réel'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Fermer'),
                    ),
                  ],
                );
              },
              child: const Text('Aide'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityCard(CommunityModel community) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _selectCommunity(community);
        },
        onLongPress: () {
          _showCommunityOptions(community);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête de la communauté
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getCommunityColor(community.community_id),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        community.nom.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            RoleBadge(role: community.role),
                          ],
                        ),
                        const SizedBox(height: 4),
                        if (community.description.isNotEmpty)
                          Text(
                            community.description,
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
              // Statistiques
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    icon: Icons.people_outline,
                    value: community.members_count.toString() ?? '?',
                    label: 'Membres',
                  ),
                  _buildStatItem(
                    icon: Icons.folder_outlined,
                    value: community.projects_count.toString() ?? '?',
                    label: 'Projets',
                  ),
                  _buildStatItem(
                    icon: Icons.calendar_today,
                    value: community.created_at != null
                        ? _formatDate(community.created_at!)
                        : 'N/A', // ✅ CORRIGÉ
                    label: 'Créée',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Bouton d'action
              PrimaryButton(
                text: 'Ouvrir',
                onPressed: () {
                  _selectCommunity(community);
                },
                fullWidth: true,
                icon: Icons.arrow_forward,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Text(label, style: AppTheme.bodyText2.copyWith(fontSize: 12)),
      ],
    );
  }

  void _selectCommunity(CommunityModel community) async {
    try {
      _communityController.setCurrentCommunity(community);

      // Charger les détails de la communauté
      await _communityController.refreshCurrentCommunity();

      Get.toNamed(AppRoutes.communityDashboard);

      Get.snackbar(
        'Communauté sélectionnée',
        'Bienvenue dans ${community.nom}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible d\'accéder à la communauté',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showCommunityOptions(CommunityModel community) {
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
              leading: const Icon(Icons.info_outline),
              title: const Text('Détails'),
              onTap: () {
                Get.back();
                _showCommunityDetails(community);
              },
            ),
            ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('Copier le code d\'invitation'),
              onTap: () {
                Get.back();
                _copyInviteCode(community);
              },
            ),
            if (community.role == 'ADMIN')
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Modifier'),
                onTap: () {
                  Get.back();
                  _editCommunity(community);
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text(
                'Quitter la communauté',
                style: TextStyle(color: Colors.red),
              ),
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
        title: Text(community.nom),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description :',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              community.description.isNotEmpty
                  ? community.description
                  : 'Aucune description',
            ),
            const SizedBox(height: 16),
            Text(
              'Code d\'invitation :',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            SelectableText(
              community.invite_code.toString(),
              style: const TextStyle(
                fontFamily: 'Courier',
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildDetailItem('Rôle', community.role),
                const SizedBox(width: 16),
                _buildDetailItem(
                  'Créée',
                  community.created_at != null
                      ? _formatDate(community.created_at!)
                      : 'N/A', // ✅ CORRIGÉ
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
          PrimaryButton(
            text: 'Ouvrir',
            onPressed: () {
              Get.back();
              _selectCommunity(community);
            },
            fullWidth: false,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.bodyText2.copyWith(fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  void _copyInviteCode(CommunityModel community) {
    // Copier dans le presse-papier
    // clipboard.setData(ClipboardData(text: community.inviteCode));

    Get.snackbar(
      'Code copié',
      'Le code d\'invitation a été copié dans le presse-papier',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _editCommunity(CommunityModel community) {
    Get.defaultDialog(
      title: 'Modifier la communauté',
      content: const Column(
        children: [
          Text(
            'Cette fonctionnalité sera disponible dans une prochaine mise à jour.',
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
      ],
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
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Aujourd'hui";
    } else if (difference.inDays == 1) {
      return 'Hier';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays} jours';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Il y a $weeks semaine${weeks > 1 ? 's' : ''}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
