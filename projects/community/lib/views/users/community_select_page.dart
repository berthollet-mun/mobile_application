import 'package:community/app/routes/app_routes.dart';
import 'package:community/app/themes/app_theme.dart';
import 'package:community/controllers/auth_controller.dart';
import 'package:community/controllers/community_controller.dart';
import 'package:community/core/utils/responsive_helper.dart';
import 'package:community/core/utils/widgets/responsive_builder.dart';
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
    final responsive = ResponsiveHelper(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mes Communautés',
          style: TextStyle(fontSize: responsive.fontSize(18)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: responsive.iconSize(24)),
            onPressed: _refreshCommunities,
            tooltip: 'Actualiser',
          ),
          IconButton(
            icon: Icon(Icons.person, size: responsive.iconSize(24)),
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
          child: _buildCommunityList(responsive),
        );
      }),
      floatingActionButton: _buildFloatingActionButtons(responsive),
      bottomNavigationBar: _buildBottomBar(responsive),
    );
  }

  /// Construction de la liste/grille des communautés
  Widget _buildCommunityList(ResponsiveHelper responsive) {
    // Sur desktop/large tablette, afficher en grille
    if (responsive.isDesktop ||
        (responsive.isTablet && responsive.screenWidth > 700)) {
      return ResponsiveContainer(
        maxWidth: 1200,
        padding: EdgeInsets.all(responsive.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            _buildHeader(responsive),
            SizedBox(height: responsive.spacing(24)),
            // Grille de communautés
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: responsive.value<int>(
                    mobile: 1,
                    tablet: 2,
                    desktop: 3,
                    largeDesktop: 4,
                  ),
                  crossAxisSpacing: responsive.spacing(16),
                  mainAxisSpacing: responsive.spacing(16),
                  childAspectRatio: responsive.value<double>(
                    mobile: 1.8,
                    tablet: 1.4,
                    desktop: 1.2,
                    largeDesktop: 1.3,
                  ),
                ),
                itemCount: _communityController.communities.length,
                itemBuilder: (context, index) {
                  return _buildCommunityCard(
                    _communityController.communities[index],
                    responsive,
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    // Sur mobile/petite tablette, afficher en liste
    return ListView(
      padding: EdgeInsets.fromLTRB(
        responsive.spacing(16),
        responsive.spacing(16),
        responsive.spacing(16),
        responsive.isMobileSmall ? 140 : 100,
      ),
      children: [
        // En-tête
        _buildHeader(responsive),
        SizedBox(height: responsive.spacing(16)),
        // Liste des communautés
        ..._communityController.communities.map((community) {
          return _buildCommunityCard(community, responsive);
        }),
        // SizedBox(height: responsive.spacing(120)), // Espace pour les FAB
      ],
    );
  }

  /// En-tête avec message de bienvenue
  Widget _buildHeader(ResponsiveHelper responsive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bonjour, ${_authController.user.value?.prenom ?? 'Utilisateur'} !',
          style: AppTheme.headline2.copyWith(fontSize: responsive.fontSize(22)),
        ),
        SizedBox(height: responsive.spacing(4)),
        Text(
          'Sélectionnez une communauté pour commencer',
          style: AppTheme.bodyText2.copyWith(fontSize: responsive.fontSize(14)),
        ),
      ],
    );
  }

  /// Carte de communauté responsive
  Widget _buildCommunityCard(
    CommunityModel community,
    ResponsiveHelper responsive,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: responsive.spacing(16)),
      elevation: responsive.value<double>(mobile: 2, tablet: 3, desktop: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.spacing(12)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(responsive.spacing(12)),
        onTap: () => _selectCommunity(community),
        onLongPress: () => _showCommunityOptions(community, responsive),
        child: Padding(
          padding: EdgeInsets.all(responsive.spacing(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête de la communauté
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: responsive.value<double>(
                      mobile: 45,
                      tablet: 50,
                      desktop: 55,
                    ),
                    height: responsive.value<double>(
                      mobile: 45,
                      tablet: 50,
                      desktop: 55,
                    ),
                    decoration: BoxDecoration(
                      color: _getCommunityColor(community.community_id),
                      borderRadius: BorderRadius.circular(
                        responsive.spacing(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        community.nom.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          fontSize: responsive.fontSize(20),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.spacing(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                community.nom,
                                style: TextStyle(
                                  fontSize: responsive.fontSize(16),
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: responsive.isMobile ? 1 : 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            RoleBadge(role: community.role),
                          ],
                        ),
                        SizedBox(height: responsive.spacing(4)),
                        if (community.description.isNotEmpty)
                          Text(
                            community.description,
                            style: AppTheme.bodyText2.copyWith(
                              fontSize: responsive.fontSize(12),
                            ),
                            maxLines: responsive.isMobile ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.spacing(16)),
              // Statistiques
              _buildStatisticsRow(community, responsive),
              SizedBox(height: responsive.spacing(16)),
              // Bouton d'action
              SizedBox(
                height: responsive.value<double>(
                  mobile: 40,
                  tablet: 44,
                  desktop: 48,
                ),
                child: PrimaryButton(
                  text: 'Ouvrir',
                  onPressed: () => _selectCommunity(community),
                  fullWidth: true,
                  icon: Icons.arrow_forward,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Ligne de statistiques responsive
  Widget _buildStatisticsRow(
    CommunityModel community,
    ResponsiveHelper responsive,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildStatItem(
            icon: Icons.people_outline,
            value: community.members_count.toString(),
            label: 'Membres',
            responsive: responsive,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            icon: Icons.folder_outlined,
            value: community.projects_count.toString(),
            label: 'Projets',
            responsive: responsive,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            icon: Icons.calendar_today,
            value: community.created_at != null
                ? _formatDate(community.created_at!)
                : 'N/A',
            label: 'Créée',
            responsive: responsive,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required ResponsiveHelper responsive,
  }) {
    return Column(
      children: [
        Icon(icon, size: responsive.iconSize(20), color: Colors.black87),
        SizedBox(height: responsive.spacing(4)),
        Text(
          value,
          style: TextStyle(
            fontSize: responsive.fontSize(13),
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),

        Text(
          label,
          style: AppTheme.bodyText2.copyWith(fontSize: responsive.fontSize(11)),
        ),
      ],
    );
  }

  /// Boutons flottants responsive
  Widget _buildFloatingActionButtons(ResponsiveHelper responsive) {
    // Sur desktop, afficher horizontalement
    if (responsive.isDesktop) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () => Get.toNamed(AppRoutes.joinCommunity),
            icon: Icon(Icons.key, size: responsive.iconSize(20)),
            label: Text(
              'Rejoindre',
              style: TextStyle(fontSize: responsive.fontSize(14)),
            ),
            heroTag: 'join_community',
          ),
          SizedBox(width: responsive.spacing(16)),
          FloatingActionButton.extended(
            onPressed: () => Get.toNamed(AppRoutes.createCommunity),
            icon: Icon(Icons.add, size: responsive.iconSize(20)),
            label: Text(
              'Créer',
              style: TextStyle(fontSize: responsive.fontSize(14)),
            ),
            heroTag: 'create_community',
          ),
        ],
      );
    }

    // Sur mobile/tablette, afficher verticalement
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (responsive.isTablet || !responsive.isMobileSmall)
          FloatingActionButton.extended(
            onPressed: () => Get.toNamed(AppRoutes.joinCommunity),
            icon: Icon(Icons.key, size: responsive.iconSize(20)),
            label: Text(
              'Rejoindre',
              style: TextStyle(fontSize: responsive.fontSize(13)),
            ),
            heroTag: 'join_community',
          )
        else
          FloatingActionButton(
            onPressed: () => Get.toNamed(AppRoutes.joinCommunity),
            heroTag: 'join_community',
            child: Icon(Icons.key, size: responsive.iconSize(24)),
          ),
        SizedBox(height: responsive.spacing(12)),
        if (responsive.isTablet || !responsive.isMobileSmall)
          FloatingActionButton.extended(
            onPressed: () => Get.toNamed(AppRoutes.createCommunity),
            icon: Icon(Icons.add, size: responsive.iconSize(20)),
            label: Text(
              'Créer',
              style: TextStyle(fontSize: responsive.fontSize(13)),
            ),
            heroTag: 'create_community',
          )
        else
          FloatingActionButton(
            onPressed: () => Get.toNamed(AppRoutes.createCommunity),
            heroTag: 'create_community',
            child: Icon(Icons.add, size: responsive.iconSize(24)),
          ),
      ],
    );
  }

  /// Barre inférieure responsive
  Widget _buildBottomBar(ResponsiveHelper responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.spacing(16)),
      color: Theme.of(context).cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_communityController.communities.length} communauté(s)',
            style: AppTheme.bodyText2.copyWith(
              fontSize: responsive.fontSize(13),
            ),
          ),
          TextButton(
            onPressed: () => _showHelpDialog(responsive),
            child: Text(
              'Aide',
              style: TextStyle(fontSize: responsive.fontSize(13)),
            ),
          ),
        ],
      ),
    );
  }

  /// Dialog d'aide responsive
  void _showHelpDialog(ResponsiveHelper responsive) {
    Get.defaultDialog(
      title: 'À propos des communautés',
      titleStyle: TextStyle(fontSize: responsive.fontSize(18)),
      content: Container(
        constraints: BoxConstraints(
          maxWidth: responsive.value<double>(
            mobile: 300,
            tablet: 400,
            desktop: 500,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Les communautés sont des espaces de travail collaboratifs où vous pouvez :',
              style: TextStyle(fontSize: responsive.fontSize(14)),
            ),
            SizedBox(height: responsive.spacing(8)),
            _buildHelpItem('• Créer et gérer des projets', responsive),
            _buildHelpItem('• Travailler avec d\'autres membres', responsive),
            _buildHelpItem('• Suivre l\'avancement des tâches', responsive),
            _buildHelpItem('• Communiquer en temps réel', responsive),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Fermer',
            style: TextStyle(fontSize: responsive.fontSize(14)),
          ),
        ),
      ],
    );
  }

  Widget _buildHelpItem(String text, ResponsiveHelper responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.spacing(2)),
      child: Text(text, style: TextStyle(fontSize: responsive.fontSize(13))),
    );
  }

  /// Options de communauté responsive
  void _showCommunityOptions(
    CommunityModel community,
    ResponsiveHelper responsive,
  ) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(responsive.spacing(20)),
            topRight: Radius.circular(responsive.spacing(20)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOptionTile(
              icon: Icons.info_outline,
              title: 'Détails',
              onTap: () {
                Get.back();
                _showCommunityDetails(community, responsive);
              },
              responsive: responsive,
            ),
            _buildOptionTile(
              icon: Icons.content_copy,
              title: 'Copier le code d\'invitation',
              onTap: () {
                Get.back();
                _copyInviteCode(community);
              },
              responsive: responsive,
            ),
            if (community.role == 'ADMIN')
              _buildOptionTile(
                icon: Icons.edit,
                title: 'Modifier',
                onTap: () {
                  Get.back();
                  _editCommunity(community, responsive);
                },
                responsive: responsive,
              ),
            const Divider(),
            _buildOptionTile(
              icon: Icons.exit_to_app,
              title: 'Quitter la communauté',
              onTap: () {
                Get.back();
                _confirmLeaveCommunity(community, responsive);
              },
              responsive: responsive,
              isDestructive: true,
            ),
            SizedBox(height: responsive.spacing(8)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ResponsiveHelper responsive,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: responsive.iconSize(24),
        color: isDestructive ? Colors.red : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: responsive.fontSize(14),
          color: isDestructive ? Colors.red : null,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: responsive.spacing(20),
        vertical: responsive.spacing(4),
      ),
    );
  }

  // === Les autres méthodes restent identiques mais avec responsive passé en paramètre ===

  void _showCommunityDetails(
    CommunityModel community,
    ResponsiveHelper responsive,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text(
          community.nom,
          style: TextStyle(fontSize: responsive.fontSize(18)),
        ),
        content: Container(
          constraints: BoxConstraints(
            maxWidth: responsive.value<double>(
              mobile: 300,
              tablet: 400,
              desktop: 500,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.fontSize(14),
                ),
              ),
              SizedBox(height: responsive.spacing(4)),
              Text(
                community.description.isNotEmpty
                    ? community.description
                    : 'Aucune description',
                style: TextStyle(fontSize: responsive.fontSize(13)),
              ),
              SizedBox(height: responsive.spacing(16)),
              Text(
                'Code d\'invitation :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.fontSize(14),
                ),
              ),
              SizedBox(height: responsive.spacing(4)),
              SelectableText(
                community.invite_code.toString(),
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: responsive.fontSize(16),
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: responsive.spacing(16)),
              Row(
                children: [
                  _buildDetailItem('Rôle', community.role, responsive),
                  SizedBox(width: responsive.spacing(16)),
                  _buildDetailItem(
                    'Créée',
                    community.created_at != null
                        ? _formatDate(community.created_at!)
                        : 'N/A',
                    responsive,
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Fermer',
              style: TextStyle(fontSize: responsive.fontSize(14)),
            ),
          ),
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

  Widget _buildDetailItem(
    String label,
    String value,
    ResponsiveHelper responsive,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.bodyText2.copyWith(fontSize: responsive.fontSize(12)),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: responsive.fontSize(14),
          ),
        ),
      ],
    );
  }

  void _editCommunity(CommunityModel community, ResponsiveHelper responsive) {
    final nameController = TextEditingController(text: community.nom);
    final descriptionController = TextEditingController(
      text: community.description,
    );

    Get.dialog(
      AlertDialog(
        title: Text(
          'Modifier la communauté',
          style: TextStyle(fontSize: responsive.fontSize(18)),
        ),
        content: Container(
          constraints: BoxConstraints(
            maxWidth: responsive.value<double>(
              mobile: 300,
              tablet: 400,
              desktop: 500,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: TextStyle(fontSize: responsive.fontSize(14)),
                  decoration: InputDecoration(
                    labelText: 'Nom de la communauté',
                    labelStyle: TextStyle(fontSize: responsive.fontSize(14)),
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(responsive.spacing(12)),
                  ),
                ),
                SizedBox(height: responsive.spacing(16)),
                TextField(
                  controller: descriptionController,
                  style: TextStyle(fontSize: responsive.fontSize(14)),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(fontSize: responsive.fontSize(14)),
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(responsive.spacing(12)),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Annuler',
              style: TextStyle(fontSize: responsive.fontSize(14)),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.dialog(
                const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );

              final success = await _communityController.updateCommunity(
                communityId: community.community_id,
                nom: nameController.text.trim(),
                description: descriptionController.text.trim(),
              );

              Get.back();
              Get.back();

              if (success) {
                await _loadCommunities();
                Get.snackbar(
                  'Succès',
                  'Communauté modifiée avec succès',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else {
                Get.snackbar(
                  'Erreur',
                  'Impossible de modifier la communauté',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: Text(
              'Enregistrer',
              style: TextStyle(fontSize: responsive.fontSize(14)),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLeaveCommunity(
    CommunityModel community,
    ResponsiveHelper responsive,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Quitter la communauté',
          style: TextStyle(fontSize: responsive.fontSize(18)),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir quitter la communauté "${community.nom}" ?',
          style: TextStyle(fontSize: responsive.fontSize(14)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Annuler',
              style: TextStyle(fontSize: responsive.fontSize(14)),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _leaveCommunity(community);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(
              'Quitter',
              style: TextStyle(fontSize: responsive.fontSize(14)),
            ),
          ),
        ],
      ),
    );
  }

  // === Méthodes de logique métier inchangées ===

  void _selectCommunity(CommunityModel community) async {
    try {
      _communityController.setCurrentCommunity(community);
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

  void _copyInviteCode(CommunityModel community) {
    Get.snackbar(
      'Code copié',
      'Le code d\'invitation a été copié dans le presse-papier',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> _leaveCommunity(CommunityModel community) async {
    // Récupérer l'ID de l'utilisateur connecté
    final userId = _authController.user.value?.user_id;

    if (userId == null) {
      Get.snackbar(
        'Erreur',
        'Utilisateur non connecté',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final success = await _communityController.leaveCommunity(
      communityId: community.community_id,
      userId: userId,
    );

    if (success) {
      await _loadCommunities();

      Get.snackbar(
        'Succès',
        'Vous avez quitté la communauté "${community.nom}"',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'Erreur',
        'Impossible de quitter la communauté',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
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
