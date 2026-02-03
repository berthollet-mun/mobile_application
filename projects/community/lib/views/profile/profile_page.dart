import 'package:community/app/routes/app_routes.dart';
import 'package:community/app/themes/app_theme.dart';
import 'package:community/controllers/auth_controller.dart';
import 'package:community/controllers/theme_controller.dart';
import 'package:community/core/utils/responsive_helper.dart';
import 'package:community/core/utils/widgets/responsive_builder.dart';
import 'package:community/data/models/user_model.dart';
import 'package:community/views/shared/widgets/button.dart';
import 'package:community/views/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController _authController = Get.find();
  final ThemeController _themeController = Get.find();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await _authController.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
          style: TextStyle(fontSize: responsive.fontSize(18)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, size: responsive.iconSize(24)),
            onPressed: () {
              _showSettings(responsive);
            },
            tooltip: 'Paramètres',
          ),
        ],
      ),
      body: Obx(() {
        final user = _authController.user.value;

        if (_authController.isLoading.value && user == null) {
          return const LoadingWidget(message: 'Chargement du profil...');
        }

        if (user == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: responsive.iconSize(64),
                  color: Colors.red,
                ),
                SizedBox(height: responsive.spacing(16)),
                Text(
                  'Impossible de charger le profil',
                  style: TextStyle(fontSize: responsive.fontSize(18)),
                ),
                SizedBox(height: responsive.spacing(16)),
                PrimaryButton(
                  text: 'Réessayer',
                  onPressed: _loadProfile,
                  fullWidth: false,
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: ResponsiveContainer(
            maxWidth: responsive.value<double>(
              mobile: double.infinity,
              tablet: 700,
              desktop: 900,
              largeDesktop: 1000,
            ),
            padding: EdgeInsets.all(responsive.contentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête du profil
                _buildProfileHeader(user, responsive),
                SizedBox(height: responsive.spacing(32)),

                // Sur desktop, afficher en grille
                if (responsive.isDesktop) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            _buildPersonalInfo(user, responsive),
                            SizedBox(height: responsive.spacing(24)),
                            _buildPreferences(responsive),
                          ],
                        ),
                      ),
                      SizedBox(width: responsive.spacing(24)),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            _buildStatistics(responsive),
                            SizedBox(height: responsive.spacing(24)),
                            _buildActions(responsive),
                          ],
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Sur mobile/tablette, afficher en colonne
                  _buildPersonalInfo(user, responsive),
                  SizedBox(height: responsive.spacing(32)),
                  _buildStatistics(responsive),
                  SizedBox(height: responsive.spacing(32)),
                  _buildPreferences(responsive),
                  SizedBox(height: responsive.spacing(32)),
                  _buildActions(responsive),
                ],

                SizedBox(height: responsive.spacing(32)),
                _buildVersionInfo(responsive),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(UserModel user, ResponsiveHelper responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.spacing(24)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(responsive.spacing(20)),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: responsive.isDesktop
          ? Row(
              children: [
                // Avatar
                _buildAvatar(user, responsive),
                SizedBox(width: responsive.spacing(32)),
                // Informations
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: AppTheme.headline1.copyWith(
                          fontSize: responsive.fontSize(24),
                        ),
                      ),
                      SizedBox(height: responsive.spacing(4)),
                      Text(
                        user.email,
                        style: AppTheme.bodyText2.copyWith(
                          fontSize: responsive.fontSize(16),
                        ),
                      ),
                      SizedBox(height: responsive.spacing(16)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.spacing(12),
                          vertical: responsive.spacing(6),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(
                            responsive.spacing(20),
                          ),
                        ),
                        child: Text(
                          'Membre depuis ${_formatDate(user.created_at)}',
                          style: AppTheme.bodyText2.copyWith(
                            fontSize: responsive.fontSize(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                // Avatar
                _buildAvatar(user, responsive),
                SizedBox(height: responsive.spacing(16)),
                // Nom et email
                Text(
                  user.fullName,
                  style: AppTheme.headline1.copyWith(
                    fontSize: responsive.fontSize(22),
                  ),
                ),
                SizedBox(height: responsive.spacing(4)),
                Text(
                  user.email,
                  style: AppTheme.bodyText2.copyWith(
                    fontSize: responsive.fontSize(15),
                  ),
                ),
                SizedBox(height: responsive.spacing(16)),
                // Date d'inscription
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.spacing(12),
                    vertical: responsive.spacing(6),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(responsive.spacing(20)),
                  ),
                  child: Text(
                    'Membre depuis ${_formatDate(user.created_at)}',
                    style: AppTheme.bodyText2.copyWith(
                      fontSize: responsive.fontSize(13),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAvatar(UserModel user, ResponsiveHelper responsive) {
    final size = responsive.value<double>(
      mobile: 80,
      tablet: 90,
      desktop: 100,
      largeDesktop: 110,
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getUserColor(user),
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: responsive.value<double>(mobile: 2.5, tablet: 3, desktop: 3.5),
        ),
      ),
      child: Center(
        child: Text(
          _getUserInitials(user),
          style: TextStyle(
            fontSize: responsive.fontSize(32),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfo(UserModel user, ResponsiveHelper responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.spacing(20)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(responsive.spacing(16)),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations personnelles',
            style: AppTheme.headline2.copyWith(
              fontSize: responsive.fontSize(18),
            ),
          ),
          SizedBox(height: responsive.spacing(16)),
          _buildInfoItem(
            icon: Icons.person_outline,
            label: 'Prénom',
            value: user.prenom,
            responsive: responsive,
          ),
          const Divider(),
          _buildInfoItem(
            icon: Icons.person_outline,
            label: 'Nom',
            value: user.nom,
            responsive: responsive,
          ),
          const Divider(),
          _buildInfoItem(
            icon: Icons.email_outlined,
            label: 'Email',
            value: user.email,
            responsive: responsive,
          ),
          SizedBox(height: responsive.spacing(16)),
          SecondaryButton(
            text: 'Modifier le profil',
            onPressed: () {
              _editProfile(user, responsive);
            },
            fullWidth: true,
            icon: Icons.edit,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required ResponsiveHelper responsive,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.spacing(12)),
      child: Row(
        children: [
          Icon(icon, size: responsive.iconSize(20), color: Colors.grey[600]),
          SizedBox(width: responsive.spacing(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.bodyText2.copyWith(
                    fontSize: responsive.fontSize(12),
                  ),
                ),
                SizedBox(height: responsive.spacing(4)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: responsive.fontSize(15),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: responsive.isMobile ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(ResponsiveHelper responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.spacing(20)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(responsive.spacing(16)),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistiques',
            style: AppTheme.headline2.copyWith(
              fontSize: responsive.fontSize(18),
            ),
          ),
          SizedBox(height: responsive.spacing(16)),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: responsive.value<int>(
              mobile: 2,
              tablet: 2,
              desktop: 2,
              largeDesktop: 2,
            ),
            crossAxisSpacing: responsive.spacing(16),
            mainAxisSpacing: responsive.spacing(16),
            childAspectRatio: responsive.value<double>(
              mobile: 1.2,
              tablet: 1.4,
              desktop: 1.5,
              largeDesktop: 1.6,
            ),
            children: [
              _buildStatCard(
                icon: Icons.groups_outlined,
                value: '0',
                label: 'Communautés',
                color: Colors.blue,
                responsive: responsive,
              ),
              _buildStatCard(
                icon: Icons.folder_outlined,
                value: '0',
                label: 'Projets',
                color: Colors.green,
                responsive: responsive,
              ),
              _buildStatCard(
                icon: Icons.task_outlined,
                value: '0',
                label: 'Tâches créées',
                color: Colors.orange,
                responsive: responsive,
              ),
              _buildStatCard(
                icon: Icons.check_circle_outline,
                value: '0',
                label: 'Tâches terminées',
                color: Colors.purple,
                responsive: responsive,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required ResponsiveHelper responsive,
  }) {
    return Container(
      padding: EdgeInsets.all(responsive.spacing(12)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(responsive.spacing(12)),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: responsive.iconSize(24), color: color),
          SizedBox(height: responsive.spacing(8)),
          Text(
            value,
            style: TextStyle(
              fontSize: responsive.fontSize(18),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: responsive.spacing(4)),
          Text(
            label,
            style: AppTheme.bodyText2.copyWith(
              fontSize: responsive.fontSize(11),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferences(ResponsiveHelper responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.spacing(20)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(responsive.spacing(16)),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Préférences',
            style: AppTheme.headline2.copyWith(
              fontSize: responsive.fontSize(18),
            ),
          ),
          SizedBox(height: responsive.spacing(16)),
          Obx(() {
            return SwitchListTile(
              title: Text(
                'Mode sombre',
                style: TextStyle(fontSize: responsive.fontSize(15)),
              ),
              subtitle: Text(
                'Activer le thème sombre',
                style: TextStyle(fontSize: responsive.fontSize(13)),
              ),
              value: _themeController.isDarkMode.value,
              onChanged: (value) {
                _themeController.switchTheme();
              },
              secondary: Icon(
                _themeController.isDarkMode.value
                    ? Icons.dark_mode
                    : Icons.light_mode,
                size: responsive.iconSize(24),
              ),
            );
          }),
          const Divider(),
          SwitchListTile(
            title: Text(
              'Notifications',
              style: TextStyle(fontSize: responsive.fontSize(15)),
            ),
            subtitle: Text(
              'Recevoir les notifications push',
              style: TextStyle(fontSize: responsive.fontSize(13)),
            ),
            value: true,
            onChanged: (value) {
              Get.snackbar(
                'Notifications',
                'Les paramètres de notification seront disponibles bientôt.',
                backgroundColor: Colors.blue,
                colorText: Colors.white,
              );
            },
            secondary: Icon(
              Icons.notifications_active_outlined,
              size: responsive.iconSize(24),
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.language_outlined,
              size: responsive.iconSize(24),
            ),
            title: Text(
              'Langue',
              style: TextStyle(fontSize: responsive.fontSize(15)),
            ),
            subtitle: Text(
              'Français',
              style: TextStyle(fontSize: responsive.fontSize(13)),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: responsive.iconSize(16),
            ),
            onTap: () {
              Get.snackbar(
                'Langue',
                'La sélection de langue sera disponible bientôt.',
                backgroundColor: Colors.blue,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActions(ResponsiveHelper responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.spacing(20)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(responsive.spacing(16)),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions',
            style: AppTheme.headline2.copyWith(
              fontSize: responsive.fontSize(18),
            ),
          ),
          SizedBox(height: responsive.spacing(16)),
          _buildActionTile(
            icon: Icons.help_outline,
            title: 'Centre d\'aide',
            color: Colors.blue,
            onTap: () {
              Get.snackbar(
                'Centre d\'aide',
                'Le centre d\'aide sera disponible bientôt.',
                backgroundColor: Colors.blue,
                colorText: Colors.white,
              );
            },
            responsive: responsive,
          ),
          const Divider(),
          _buildActionTile(
            icon: Icons.description_outlined,
            title: 'Conditions d\'utilisation',
            color: Colors.green,
            onTap: () {
              _showDialog(
                'Conditions d\'utilisation',
                'En utilisant MarPro+, vous acceptez nos conditions d\'utilisation.',
                responsive,
              );
            },
            responsive: responsive,
          ),
          const Divider(),
          _buildActionTile(
            icon: Icons.security_outlined,
            title: 'Politique de confidentialité',
            color: Colors.purple,
            onTap: () {
              _showDialog(
                'Politique de confidentialité',
                'Nous respectons votre vie privée. Vos données sont sécurisées.',
                responsive,
              );
            },
            responsive: responsive,
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red,
              size: responsive.iconSize(24),
            ),
            title: Text(
              'Déconnexion',
              style: TextStyle(
                color: Colors.red,
                fontSize: responsive.fontSize(15),
              ),
            ),
            onTap: () => _confirmLogout(responsive),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    required ResponsiveHelper responsive,
  }) {
    return ListTile(
      leading: Icon(icon, color: color, size: responsive.iconSize(24)),
      title: Text(title, style: TextStyle(fontSize: responsive.fontSize(15))),
      trailing: Icon(Icons.arrow_forward_ios, size: responsive.iconSize(16)),
      onTap: onTap,
    );
  }

  Widget _buildVersionInfo(ResponsiveHelper responsive) {
    return Center(
      child: Column(
        children: [
          Text(
            'MarPro+ v1.0.0',
            style: AppTheme.bodyText2.copyWith(
              fontSize: responsive.fontSize(14),
            ),
          ),
          SizedBox(height: responsive.spacing(4)),
          Text(
            '© 2024 MarPro+. Tous droits réservés.',
            style: AppTheme.bodyText2.copyWith(
              fontSize: responsive.fontSize(12),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettings(ResponsiveHelper responsive) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(responsive.spacing(20)),
            topRight: Radius.circular(responsive.spacing(20)),
          ),
        ),
        padding: EdgeInsets.only(bottom: responsive.spacing(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: responsive.spacing(12)),
              width: responsive.value<double>(
                mobile: 40,
                tablet: 50,
                desktop: 60,
              ),
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _buildSettingsTile(
              icon: Icons.edit,
              title: 'Modifier le profil',
              onTap: () {
                Get.back();
                _editProfile(_authController.user.value!, responsive);
              },
              responsive: responsive,
            ),
            _buildSettingsTile(
              icon: Icons.notifications,
              title: 'Notifications',
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Notifications',
                  'Les paramètres de notification seront disponibles bientôt.',
                  backgroundColor: Colors.blue,
                  colorText: Colors.white,
                );
              },
              responsive: responsive,
            ),
            _buildSettingsTile(
              icon: Icons.security,
              title: 'Sécurité',
              onTap: () {
                Get.back();
                _showSecuritySettings(responsive);
              },
              responsive: responsive,
            ),
            _buildSettingsTile(
              icon: Icons.help_outline,
              title: 'Aide et support',
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Support',
                  'Le support sera disponible bientôt.',
                  backgroundColor: Colors.blue,
                  colorText: Colors.white,
                );
              },
              responsive: responsive,
            ),
            const Divider(),
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: 'À propos',
              onTap: () {
                Get.back();
                _showAbout(responsive);
              },
              responsive: responsive,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ResponsiveHelper responsive,
  }) {
    return ListTile(
      leading: Icon(icon, size: responsive.iconSize(24)),
      title: Text(title, style: TextStyle(fontSize: responsive.fontSize(15))),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: responsive.spacing(20),
        vertical: responsive.spacing(4),
      ),
    );
  }

  void _showDialog(String title, String content, ResponsiveHelper responsive) {
    Get.defaultDialog(
      title: title,
      titleStyle: TextStyle(fontSize: responsive.fontSize(18)),
      content: Container(
        constraints: BoxConstraints(
          maxWidth: responsive.value<double>(
            mobile: 300,
            tablet: 400,
            desktop: 500,
          ),
        ),
        child: Text(
          content,
          style: TextStyle(fontSize: responsive.fontSize(14)),
        ),
      ),
    );
  }

  void _editProfile(UserModel user, ResponsiveHelper responsive) {
    Get.defaultDialog(
      title: 'Modifier le profil',
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
          children: [
            Text(
              'Cette fonctionnalité sera disponible dans une prochaine mise à jour.',
              style: TextStyle(fontSize: responsive.fontSize(14)),
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
      ],
    );
  }

  void _showSecuritySettings(ResponsiveHelper responsive) {
    Get.defaultDialog(
      title: 'Sécurité',
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
          children: [
            Text(
              'Modifier le mot de passe',
              style: TextStyle(fontSize: responsive.fontSize(15)),
            ),
            SizedBox(height: responsive.spacing(16)),
            Text(
              'Cette fonctionnalité sera disponible dans une prochaine mise à jour.',
              style: TextStyle(fontSize: responsive.fontSize(14)),
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
      ],
    );
  }

  void _showAbout(ResponsiveHelper responsive) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'À propos de MarPro+',
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
                'MarPro+ est une application de gestion collaborative de projets.',
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
              SizedBox(height: responsive.spacing(16)),
              Text(
                'Version: 1.0.0',
                style: TextStyle(fontSize: responsive.fontSize(14)),
              ),
              SizedBox(height: responsive.spacing(8)),
              Text(
                'Développé avec ❤️',
                style: TextStyle(fontSize: responsive.fontSize(14)),
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
        ],
      ),
    );
  }

  void _confirmLogout(ResponsiveHelper responsive) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Déconnexion',
          style: TextStyle(fontSize: responsive.fontSize(18)),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir vous déconnecter ?',
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
              _logout();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(
              'Se déconnecter',
              style: TextStyle(fontSize: responsive.fontSize(14)),
            ),
          ),
        ],
      ),
    );
  }

  // === Méthodes de logique métier inchangées ===

  void _logout() async {
    await _authController.logout();
    Get.offAllNamed(AppRoutes.welcome);

    Get.snackbar(
      'Déconnecté',
      'Vous avez été déconnecté avec succès.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  String _getUserInitials(UserModel user) {
    return '${user.prenom[0]}${user.nom[0]}'.toUpperCase();
  }

  Color _getUserColor(UserModel user) {
    final hash = user.email.hashCode;
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
    return colors[hash.abs() % colors.length];
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 30) {
      return '${difference.inDays} jours';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months mois';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years an${years > 1 ? 's' : ''}';
    }
  }
}
