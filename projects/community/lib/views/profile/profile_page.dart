import 'package:community/app/routes/app_routes.dart';
import 'package:community/app/themes/app_theme.dart';
import 'package:community/controllers/auth_controller.dart';
import 'package:community/controllers/theme_controller.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettings();
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
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Impossible de charger le profil',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête du profil
                _buildProfileHeader(user),
                const SizedBox(height: 32),
                // Informations personnelles
                _buildPersonalInfo(user),
                const SizedBox(height: 32),
                // Statistiques
                _buildStatistics(),
                const SizedBox(height: 32),
                // Préférences
                _buildPreferences(),
                const SizedBox(height: 32),
                // Actions
                _buildActions(),
                const SizedBox(height: 32),
                // Version
                _buildVersionInfo(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: _getUserColor(user),
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                _getUserInitials(user),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Nom et email
          Text(user.fullName, style: AppTheme.headline1.copyWith(fontSize: 24)),
          const SizedBox(height: 4),
          Text(user.email, style: AppTheme.bodyText2.copyWith(fontSize: 16)),
          const SizedBox(height: 16),
          // Date d'inscription
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Membre depuis ${_formatDate(user.created_at)}',
              style: AppTheme.bodyText2.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(UserModel user) {
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
            'Informations personnelles',
            style: AppTheme.headline2.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildInfoItem(
            icon: Icons.person_outline,
            label: 'Prénom',
            value: user.prenom,
          ),
          const Divider(),
          _buildInfoItem(
            icon: Icons.person_outline,
            label: 'Nom',
            value: user.nom,
          ),
          const Divider(),
          _buildInfoItem(
            icon: Icons.email_outlined,
            label: 'Email',
            value: user.email,
          ),
          const SizedBox(height: 16),
          SecondaryButton(
            text: 'Modifier le profil',
            onPressed: () {
              _editProfile(user);
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTheme.bodyText2.copyWith(fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
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
            style: AppTheme.headline2.copyWith(fontSize: 18),
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
                icon: Icons.groups_outlined,
                value: '0',
                label: 'Communautés',
                color: Colors.blue,
              ),
              _buildStatCard(
                icon: Icons.folder_outlined,
                value: '0',
                label: 'Projets',
                color: Colors.green,
              ),
              _buildStatCard(
                icon: Icons.task_outlined,
                value: '0',
                label: 'Tâches créées',
                color: Colors.orange,
              ),
              _buildStatCard(
                icon: Icons.check_circle_outline,
                value: '0',
                label: 'Tâches terminées',
                color: Colors.purple,
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
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.bodyText2.copyWith(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferences() {
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
          Text('Préférences', style: AppTheme.headline2.copyWith(fontSize: 18)),
          const SizedBox(height: 16),
          Obx(() {
            return SwitchListTile(
              title: const Text('Mode sombre'),
              subtitle: const Text('Activer le thème sombre'),
              value: _themeController.isDarkMode.value,
              onChanged: (value) {
                _themeController.switchTheme();
              },
              secondary: Icon(
                _themeController.isDarkMode.value
                    ? Icons.dark_mode
                    : Icons.light_mode,
              ),
            );
          }),
          const Divider(),
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Recevoir les notifications push'),
            value: true,
            onChanged: (value) {
              Get.snackbar(
                'Notifications',
                'Les paramètres de notification seront disponibles bientôt.',
                backgroundColor: Colors.blue,
                colorText: Colors.white,
              );
            },
            secondary: const Icon(Icons.notifications_active_outlined),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text('Langue'),
            subtitle: const Text('Français'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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

  Widget _buildActions() {
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
          Text('Actions', style: AppTheme.headline2.copyWith(fontSize: 18)),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.blue),
            title: const Text('Centre d\'aide'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.snackbar(
                'Centre d\'aide',
                'Le centre d\'aide sera disponible bientôt.',
                backgroundColor: Colors.blue,
                colorText: Colors.white,
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.description_outlined,
              color: Colors.green,
            ),
            title: const Text('Conditions d\'utilisation'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.defaultDialog(
                title: 'Conditions d\'utilisation',
                content: const Column(
                  children: [
                    Text(
                      'En utilisant MarPro+, vous acceptez nos conditions d\'utilisation.',
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.security_outlined, color: Colors.purple),
            title: const Text('Politique de confidentialité'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.defaultDialog(
                title: 'Politique de confidentialité',
                content: const Column(
                  children: [
                    Text(
                      'Nous respectons votre vie privée. Vos données sont sécurisées.',
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Déconnexion',
              style: TextStyle(color: Colors.red),
            ),
            onTap: _confirmLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildVersionInfo() {
    return Center(
      child: Column(
        children: [
          Text('MarPro+ v1.0.0', style: AppTheme.bodyText2),
          const SizedBox(height: 4),
          Text(
            '© 2024 MarPro+. Tous droits réservés.',
            style: AppTheme.bodyText2.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showSettings() {
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
              leading: const Icon(Icons.edit),
              title: const Text('Modifier le profil'),
              onTap: () {
                Get.back();
                _editProfile(_authController.user.value!);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Notifications',
                  'Les paramètres de notification seront disponibles bientôt.',
                  backgroundColor: Colors.blue,
                  colorText: Colors.white,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Sécurité'),
              onTap: () {
                Get.back();
                _showSecuritySettings();
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Aide et support'),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Support',
                  'Le support sera disponible bientôt.',
                  backgroundColor: Colors.blue,
                  colorText: Colors.white,
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('À propos'),
              onTap: () {
                Get.back();
                _showAbout();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile(UserModel user) {
    Get.defaultDialog(
      title: 'Modifier le profil',
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

  void _showSecuritySettings() {
    Get.defaultDialog(
      title: 'Sécurité',
      content: const Column(
        children: [
          Text('Modifier le mot de passe'),
          SizedBox(height: 16),
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

  void _showAbout() {
    Get.dialog(
      AlertDialog(
        title: const Text('À propos de MarPro+'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MarPro+ est une application de gestion collaborative de projets.',
            ),
            SizedBox(height: 16),
            Text('Version: 1.0.0'),
            SizedBox(height: 8),
            Text('Développé avec ❤️'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
        ],
      ),
    );
  }

  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              Get.back();
              _logout();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }

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
