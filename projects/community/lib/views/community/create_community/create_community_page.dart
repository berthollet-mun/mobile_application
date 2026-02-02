import 'package:community/app/routes/app_routes.dart';
import 'package:community/app/themes/app_theme.dart';
import 'package:community/controllers/community_controller.dart';
import 'package:community/core/utils/validators.dart';
import 'package:community/views/shared/widgets/button.dart';
import 'package:community/views/shared/widgets/form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateCommunityPage extends StatefulWidget {
  const CreateCommunityPage({super.key});

  @override
  State<CreateCommunityPage> createState() => _CreateCommunityPageState();
}

class _CreateCommunityPageState extends State<CreateCommunityPage> {
  final CommunityController _communityController = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une communauté'),
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
                      Icons.groups,
                      size: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Créez votre espace de travail',
                      style: AppTheme.headline2,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Une communauté est un espace où vous pouvez collaborer avec votre équipe sur des projets.',
                      style: AppTheme.bodyText2,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Formulaire
                CustomFormField(
                  controller: _nameController,
                  label: 'Nom de la communauté',
                  hintText: 'Ex: Équipe Marketing',
                  prefixIcon: Icons.people_outline,
                  validator: (value) =>
                      Validators.validateRequired(value, 'Le nom'),
                  isRequired: true,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optionnelle)',
                    hintText: 'Décrivez l\'objectif de cette communauté...',
                    prefixIcon: Icon(Icons.description_outlined),
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  minLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 32),
                // Informations importantes
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Informations importantes',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Vous serez automatiquement nommé ADMIN de cette communauté',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '• Vous pourrez inviter d\'autres membres après la création',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '• Un code d\'invitation unique sera généré',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Bouton de création
                Obx(() {
                  if (_communityController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return PrimaryButton(
                    text: 'Créer la communauté',
                    onPressed: _createCommunity,
                    fullWidth: true,
                    icon: Icons.add_circle_outline,
                  );
                }),
                const SizedBox(height: 16),
                // Lien pour rejoindre
                TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.joinCommunity);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Rejoindre une communauté existante'),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: Theme.of(context).primaryColor,
                      ),
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

  Future<void> _createCommunity() async {
    if (_formKey.currentState!.validate()) {
      final community = await _communityController.createCommunity(
        nom: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      if (community != null) {
        Get.offNamed(AppRoutes.communityDashboard);

        Get.snackbar(
          'Succès !',
          'La communauté "${community.nom}" a été créée avec succès.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'Erreur',
          'Impossible de créer la communauté. Veuillez réessayer.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
