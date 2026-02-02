import 'package:community/app/themes/app_theme.dart';
import 'package:community/controllers/community_controller.dart';
import 'package:community/data/models/community_model.dart';
import 'package:community/data/models/member_model.dart';
import 'package:community/views/shared/widgets/empty_state.dart';
import 'package:community/views/shared/widgets/loading_widget.dart';
import 'package:community/views/shared/widgets/role_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MembersListPage extends StatefulWidget {
  const MembersListPage({super.key});

  @override
  State<MembersListPage> createState() => _MembersListPageState();
}

class _MembersListPageState extends State<MembersListPage> {
  final CommunityController _communityController = Get.find();

  late CommunityModel _community;
  List<MemberModel> _members = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _community = _communityController.currentCommunity.value!;
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final members = await _communityController.getCommunityMembers(
        _community.community_id,
      );
      setState(() {
        _members = members;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erreur de chargement: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshMembers() async {
    await _loadMembers();
  }

  void _showMemberOptions(MemberModel member) {
    if (_community.role != 'ADMIN') return;

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
            if (member.role != 'ADMIN')
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Modifier le rôle'),
                onTap: () {
                  Get.back();
                  _changeMemberRole(member);
                },
              ),
            if (member.role != 'ADMIN') const Divider(),
            if (member.role != 'ADMIN')
              ListTile(
                leading: const Icon(Icons.person_remove, color: Colors.red),
                title: const Text(
                  'Retirer du groupe',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Get.back();
                  _confirmRemoveMember(member);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _changeMemberRole(MemberModel member) {
    Get.dialog(
      AlertDialog(
        title: const Text('Changer le rôle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Membre'),
              leading: const Icon(Icons.person_outline),
              onTap: () {
                Get.back();
                _updateMemberRole(member, 'MEMBRE');
              },
            ),
            ListTile(
              title: const Text('Responsable'),
              leading: const Icon(Icons.star_border),
              onTap: () {
                Get.back();
                _updateMemberRole(member, 'RESPONSABLE');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateMemberRole(MemberModel member, String newRole) async {
    try {
      final success = await _communityController.updateMemberRole(
        communityId: _community.community_id,
        memberId: member.id,
        role: newRole,
      );

      if (success) {
        await _loadMembers();
        Get.snackbar(
          'Rôle mis à jour',
          'Le rôle de ${member.fullName} a été changé en $newRole',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de mettre à jour le rôle',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _confirmRemoveMember(MemberModel member) {
    Get.dialog(
      AlertDialog(
        title: const Text('Retirer du groupe'),
        content: Text(
          'Êtes-vous sûr de vouloir retirer ${member.fullName} de la communauté ?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              Get.back();
              _removeMember(member);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Retirer'),
          ),
        ],
      ),
    );
  }

  void _removeMember(MemberModel member) async {
    try {
      final success = await _communityController.removeMember(
        communityId: _community.community_id,
        memberId: member.id,
      );

      if (success) {
        await _loadMembers();
        Get.snackbar(
          'Membre retiré',
          '${member.fullName} a été retiré de la communauté',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de retirer le membre',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membres - ${_community.nom}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMembers,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Chargement des membres...')
          : _error.isNotEmpty
          ? EmptyStateWidget(
              title: 'Erreur',
              message: _error,
              icon: Icons.error_outline,
              onAction: _refreshMembers,
              actionLabel: 'Réessayer',
            )
          : _members.isEmpty
          ? EmptyStateWidget(
              title: 'Aucun membre',
              message: 'Aucun membre dans cette communauté pour le moment.',
              icon: Icons.people_outline,
            )
          : RefreshIndicator(
              onRefresh: _refreshMembers,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _members.length,
                itemBuilder: (context, index) {
                  final member = _members[index];
                  return _buildMemberCard(member);
                },
              ),
            ),
    );
  }

  Widget _buildMemberCard(MemberModel member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getMemberColor(member),
          child: Text(
            _getMemberInitials(member),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(member.fullName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member.email),
            const SizedBox(height: 4),
            Text(
              'Rejoint le ${_formatDate(member.joinedAt)}',
              style: AppTheme.bodyText2.copyWith(fontSize: 12),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoleBadge(role: member.role),
            if (_community.role == 'ADMIN' && member.role != 'ADMIN')
              IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                onPressed: () => _showMemberOptions(member),
                tooltip: 'Options',
              ),
          ],
        ),
        onTap: () {
          _showMemberDetails(member);
        },
      ),
    );
  }

  void _showMemberDetails(MemberModel member) {
    Get.dialog(
      AlertDialog(
        title: Text(member.fullName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${member.email}'),
            const SizedBox(height: 8),
            Text('Rôle: ${member.role}'),
            const SizedBox(height: 8),
            Text('Rejoint le: ${_formatDate(member.joinedAt)}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
        ],
      ),
    );
  }

  Color _getMemberColor(MemberModel member) {
    final hash = member.email.hashCode;
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

  String _getMemberInitials(MemberModel member) {
    return '${member.prenom[0]}${member.nom[0]}'.toUpperCase();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
