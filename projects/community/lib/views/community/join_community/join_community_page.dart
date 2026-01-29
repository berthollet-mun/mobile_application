import 'package:community/app/routes/app_routes.dart';
import 'package:community/app/themes/app_theme.dart';
import 'package:community/controllers/community_controller.dart';
import 'package:community/core/utils/validators.dart';
import 'package:community/views/shared/widgets/button.dart';
import 'package:community/views/shared/widgets/form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinCommunityPage extends StatefulWidget {
  const JoinCommunityPage({super.key});

  @override
  State<JoinCommunityPage> createState() => _JoinCommunityPageState();
}

class _JoinCommunityPageState extends State<JoinCommunityPage> {
  final CommunityController _communityController = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _inviteCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejoindre une communauté'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.key,
                      size: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text('Rejoignez une équipe', style: AppTheme.headline2),
                    const SizedBox(height: 8),
                    Text(
                      'Entrez le code d\'invitation fourni par l\'administrateur de la communauté.',
                      style: AppTheme.bodyText2,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Champ de code
                CustomFormField(
                  controller: _inviteCodeController,
                  label: 'Code d\'invitation',
                  hintText: 'Ex: A1B2C3D4',
                  prefixIcon: Icons.vpn_key_outlined,
                  validator: Validators.validateInviteCode,
                  isRequired: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _joinCommunity(),
                ),
                const SizedBox(height: 16),
                // Exemple de code
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.help_outline,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'À quoi ressemble un code d\'invitation ?',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Exemple: A1B2C3D4 (8 caractères, lettres et chiffres)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Bouton de rejoindre
                Obx(() {
                  if (_communityController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return PrimaryButton(
                    text: 'Rejoindre la communauté',
                    onPressed: _joinCommunity,
                    fullWidth: true,
                    icon: Icons.login,
                  );
                }),
                const SizedBox(height: 16),
                // Lien pour créer
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.createCommunity);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Créer une nouvelle communauté'),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Section d'aide
                Container(
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
                        'Besoin d\'aide ?',
                        style: AppTheme.headline2.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Pour rejoindre une communauté :',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '1. Demandez le code d\'invitation à un administrateur',
                      ),
                      const SizedBox(height: 4),
                      const Text('2. Saisissez le code ci-dessus'),
                      const SizedBox(height: 4),
                      const Text('3. Cliquez sur "Rejoindre la communauté"'),
                      const SizedBox(height: 16),
                      const Text(
                        'Une fois accepté, vous pourrez :',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      const Text('• Participer aux projets existants'),
                      const SizedBox(height: 4),
                      const Text(
                        '• Créer de nouvelles tâches (selon votre rôle)',
                      ),
                      const SizedBox(height: 4),
                      const Text('• Collaborer avec les autres membres'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _joinCommunity() async {
    if (_formKey.currentState!.validate()) {
      final success = await _communityController.joinCommunity(
        _inviteCodeController.text.trim().toUpperCase(),
      );

      if (success) {
        Get.offNamed(AppRoutes.communitySelect);

        Get.snackbar(
          'Succès !',
          'Vous avez rejoint la communauté avec succès.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Erreur',
          'Code d\'invitation invalide ou expiré.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }
}
