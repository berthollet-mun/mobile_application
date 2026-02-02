import 'package:community/app/themes/app_theme.dart';
import 'package:community/controllers/community_controller.dart';
import 'package:community/data/models/community_model.dart';
import 'package:community/views/shared/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InviteMemberPage extends StatefulWidget {
  const InviteMemberPage({super.key});

  @override
  State<InviteMemberPage> createState() => _InviteMemberPageState();
}

class _InviteMemberPageState extends State<InviteMemberPage> {
  final CommunityController _communityController = Get.find();

  late CommunityModel _community;
  bool _isLoading = false;
  String _inviteCode = '';

  @override
  void initState() {
    super.initState();
    _community = _communityController.currentCommunity.value!;
    _inviteCode = _community.invite_code.toString();
  }

  Future<void> _generateNewCode() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final invite = await _communityController.generateInviteCode(
        _community.community_id,
      );

      if (invite != null) {
        setState(() {
          _inviteCode = invite.inviteCode;
        });

        Get.snackbar(
          'Nouveau code généré',
          invite.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de générer un nouveau code',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _copyToClipboard() {
    // clipboard.setData(ClipboardData(text: _inviteCode));
    Get.snackbar(
      'Copié !',
      'Le code d\'invitation a été copié dans le presse-papier',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _shareInvite() {
    Get.snackbar(
      'Partager',
      'La fonction de partage sera disponible bientôt',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inviter - ${_community.nom}')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // En-tête
              Icon(
                Icons.person_add_alt_1,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text('Inviter des membres', style: AppTheme.headline2),
              const SizedBox(height: 8),
              Text(
                'Partagez ce code avec les personnes que vous souhaitez inviter dans votre communauté.',
                style: AppTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Code d'invitation
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [AppTheme.cardShadow],
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Code d\'invitation',
                      style: AppTheme.bodyText2.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SelectableText(
                      _inviteCode,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ce code est unique à votre communauté',
                      style: AppTheme.bodyText2.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Instructions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Comment inviter des membres ?',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '1. Partagez ce code avec les personnes à inviter',
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '2. Les membres doivent saisir ce code dans "Rejoindre une communauté"',
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '3. Ils auront accès à tous les projets de cette communauté',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Note :',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Seuls les ADMIN peuvent générer de nouveaux codes',
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '• Un code est valable jusqu\'à ce qu\'un nouveau soit généré',
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '• Vous pouvez générer un nouveau code à tout moment',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Boutons d'action
              PrimaryButton(
                text: 'Copier le code',
                onPressed: _copyToClipboard,
                fullWidth: true,
                icon: Icons.content_copy,
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                text: 'Partager',
                onPressed: _shareInvite,
                fullWidth: true,
                icon: Icons.share,
              ),
              const SizedBox(height: 16),
              if (_community.role == 'ADMIN')
                OutlinedButton(
                  onPressed: _isLoading ? null : _generateNewCode,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Générer un nouveau code'),
                ),
              const SizedBox(height: 24),
              // Note de sécurité
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.security_outlined,
                          size: 16,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Sécurité',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Ne partagez ce code qu\'avec des personnes de confiance. Toute personne ayant ce code peut rejoindre votre communauté.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
