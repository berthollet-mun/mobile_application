import 'package:community/views/shared/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:community/app/routes/app_routes.dart';
import 'package:community/app/themes/app_theme.dart';

class PricingInfoPage extends StatelessWidget {
  const PricingInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarifs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // En-tête
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Theme.of(context).primaryColor.withOpacity(0.05),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Des tarifs adaptés à vos besoins',
                    style: AppTheme.headline1.copyWith(
                      fontSize: 32,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Commencez gratuitement, passez au premium quand vous êtes prêt',
                    style: AppTheme.bodyText1.copyWith(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Plans
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Plan Gratuit
                  _buildPlanCard(
                    context,
                    title: 'Gratuit',
                    price: '0€',
                    period: 'pour toujours',
                    color: Colors.blue,
                    icon: Icons.free_breakfast,
                    features: [
                      'Jusqu\'à 3 communautés',
                      'Jusqu\'à 5 projets par communauté',
                      'Jusqu\'à 10 membres par communauté',
                      'Tableau Kanban basique',
                      'Historique des 30 derniers jours',
                      'Support par email',
                    ],
                    isPopular: false,
                    buttonText: 'Commencer gratuitement',
                    onPressed: () {
                      Get.toNamed(AppRoutes.register);
                    },
                  ),
                  const SizedBox(height: 32),
                  // Plan Premium
                  _buildPlanCard(
                    context,
                    title: 'Premium',
                    price: '9,99€',
                    period: 'par mois',
                    color: Colors.purple,
                    icon: Icons.workspace_premium,
                    features: [
                      'Communautés illimitées',
                      'Projets illimités',
                      'Membres illimités',
                      'Tableau Kanban avancé',
                      'Historique complet',
                      'Support prioritaire',
                      'Export de données',
                      'Statistiques détaillées',
                      'Thèmes personnalisables',
                      'Intégrations (bientôt)',
                    ],
                    isPopular: true,
                    buttonText: 'Essayer Premium',
                    onPressed: () {
                      _showPremiumDialog(context);
                    },
                  ),
                  const SizedBox(height: 32),
                  // Entreprise
                  _buildPlanCard(
                    context,
                    title: 'Entreprise',
                    price: 'Personnalisé',
                    period: 'sur devis',
                    color: Colors.teal,
                    icon: Icons.business,
                    features: [
                      'Toutes les fonctionnalités Premium',
                      'SSO (Single Sign-On)',
                      'API personnalisée',
                      'Support dédié 24/7',
                      'Formation de l\'équipe',
                      'Déploiement sur site',
                      'SLA 99.9%',
                      'Audit de sécurité',
                    ],
                    isPopular: false,
                    buttonText: 'Contactez-nous',
                    onPressed: () {
                      _showEnterpriseDialog(context);
                    },
                  ),
                ],
              ),
            ),
            // Comparaison
            Container(
              padding: const EdgeInsets.all(24),
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Comparaison des plans', style: AppTheme.headline2),
                  const SizedBox(height: 24),
                  _buildComparisonTable(context),
                ],
              ),
            ),
            // FAQ
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Questions fréquentes', style: AppTheme.headline2),
                  const SizedBox(height: 24),
                  _buildFAQItem(
                    context,
                    question: 'Puis-je changer de plan à tout moment ?',
                    answer:
                        'Oui, vous pouvez passer du plan gratuit au plan premium à tout moment. Le changement est instantané.',
                  ),
                  _buildFAQItem(
                    context,
                    question: 'Y a-t-il un engagement ?',
                    answer:
                        'Non, vous pouvez annuler votre abonnement premium à tout moment. Aucun engagement n\'est requis.',
                  ),
                  _buildFAQItem(
                    context,
                    question: 'Les données sont-elles sauvegardées ?',
                    answer:
                        'Oui, nous sauvegardons vos données quotidiennement. Vos projets et tâches sont en sécurité.',
                  ),
                  _buildFAQItem(
                    context,
                    question: 'Puis-je essayer Premium gratuitement ?',
                    answer:
                        'Oui, nous proposons un essai gratuit de 14 jours pour le plan Premium.',
                  ),
                  _buildFAQItem(
                    context,
                    question: 'Quels moyens de paiement acceptez-vous ?',
                    answer:
                        'Nous acceptons les cartes de crédit (Visa, Mastercard), PayPal et virements bancaires pour les plans Entreprise.',
                  ),
                ],
              ),
            ),
            // Appel à l'action final
            Container(
              padding: const EdgeInsets.all(32),
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              child: Column(
                children: [
                  Text(
                    'Prêt à commencer ?',
                    style: AppTheme.headline2.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Rejoignez des milliers d\'équipes qui gèrent déjà leurs projets avec MarPro+',
                    style: AppTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          text: 'Commencer gratuitement',
                          onPressed: () {
                            Get.toNamed(AppRoutes.register);
                          },
                          icon: Icons.rocket_launch,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.welcome);
                    },
                    child: Text(
                      'Retour à l\'accueil',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    required String period,
    required Color color,
    required IconData icon,
    required List<String> features,
    required bool isPopular,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isPopular ? color.withOpacity(0.3) : Colors.black12,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: isPopular ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Text(
                'LE PLUS POPULAIRE',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTheme.headline2.copyWith(
                              fontSize: 24,
                              color: color,
                            ),
                          ),
                          Text(period, style: AppTheme.bodyText2),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    if (price != 'Personnalisé')
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          '/mois',
                          style: AppTheme.bodyText2.copyWith(fontSize: 16),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                ...features.map((feature) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, color: color, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(feature, style: AppTheme.bodyText1),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 32),
                PrimaryButton(
                  text: buttonText,
                  onPressed: onPressed,
                  fullWidth: true,
                  backgroundColor: color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable(BuildContext context) {
    final features = [
      'Fonctionnalité',
      'Communautés',
      'Projets par communauté',
      'Membres par communauté',
      'Tableau Kanban',
      'Historique',
      'Support',
      'Export de données',
      'API',
    ];

    final freePlan = [
      'Gratuit',
      '3',
      '5',
      '10',
      'Basique',
      '30 jours',
      'Email',
      'Non',
      'Non',
    ];

    final premiumPlan = [
      'Premium',
      'Illimité',
      'Illimité',
      'Illimité',
      'Avancé',
      'Complet',
      'Prioritaire',
      'Oui',
      'Basique',
    ];

    final enterprisePlan = [
      'Entreprise',
      'Illimité',
      'Illimité',
      'Illimité',
      'Avancé',
      'Complet',
      'Dédié 24/7',
      'Oui',
      'Personnalisée',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text(
              features[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              freePlan[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              premiumPlan[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              enterprisePlan[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: List.generate(features.length - 1, (index) {
          final i = index + 1;
          return DataRow(
            cells: [
              DataCell(Text(features[i])),
              DataCell(Text(freePlan[i])),
              DataCell(Text(premiumPlan[i])),
              DataCell(Text(enterprisePlan[i])),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFAQItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(answer, style: AppTheme.bodyText2),
        ],
      ),
    );
  }

  void _showPremiumDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Essai Premium'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Le plan Premium est actuellement en développement.'),
            SizedBox(height: 16),
            Text(
              'Pour l\'instant, profitez de toutes les fonctionnalités gratuitement !',
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
          PrimaryButton(
            text: 'Commencer gratuitement',
            onPressed: () {
              Get.back();
              Get.toNamed(AppRoutes.register);
            },
            fullWidth: false,
          ),
        ],
      ),
    );
  }

  void _showEnterpriseDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Plan Entreprise'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pour les entreprises ayant des besoins spécifiques :'),
            SizedBox(height: 8),
            Text('• Support dédié'),
            Text('• Déploiement personnalisé'),
            Text('• Formation sur mesure'),
            Text('• Intégrations spécifiques'),
            SizedBox(height: 16),
            Text('Contactez-nous à : contact@marpro-plus.com'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
          SecondaryButton(
            text: 'Copier l\'email',
            onPressed: () {
              // Copier l'email dans le presse-papier
              // clipboard.setData(const ClipboardData(text: 'contact@marpro-plus.com'));
              Get.back();
              Get.snackbar(
                'Email copié',
                'contact@marpro-plus.com',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            fullWidth: false,
          ),
        ],
      ),
    );
  }
}
