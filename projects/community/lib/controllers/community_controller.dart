import 'package:community/core/services/Community_service.dart';
import 'package:community/data/models/community_model.dart';
import 'package:community/data/models/invite_model.dart';
import 'package:community/data/models/member_model.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController {
  final CommunityService _communityService = Get.find();

  final RxList<CommunityModel> communities = <CommunityModel>[].obs;
  final Rx<CommunityModel?> currentCommunity = Rx<CommunityModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<MemberModel> currentMembers = <MemberModel>[].obs;

  // Méthodes existantes (garder les vôtres)
  Future<void> loadCommunities() async {
    try {
      isLoading.value = true;
      error.value = '';
      final communitiesList = await _communityService.getUserCommunities();
      communities.assignAll(communitiesList);
    } catch (e) {
      error.value = 'Erreur de chargement: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<CommunityModel?> createCommunity({
    required String nom,
    required String description,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      final community = await _communityService.createCommunity(
        nom: nom,
        description: description,
      );
      if (community != null) {
        communities.add(community);
        currentCommunity.value = community;
        return community;
      }
      return null;
    } catch (e) {
      error.value = 'Erreur de création: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> joinCommunity(String inviteCode) async {
    try {
      isLoading.value = true;
      error.value = '';
      final success = await _communityService.joinCommunity(inviteCode);
      if (success) {
        await loadCommunities();
      }
      return success;
    } catch (e) {
      error.value = 'Erreur de rejoindre: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setCurrentCommunity(CommunityModel community) async {
    currentCommunity.value = community;
  }

  Future<void> refreshCurrentCommunity() async {
    if (currentCommunity.value != null) {
      try {
        final community = await _communityService.getCommunityDetails(
          currentCommunity.value!.community_id,
        );
        if (community != null) {
          currentCommunity.value = community;
        }
      } catch (e) {
        error.value = 'Erreur de rafraîchissement: $e';
      }
    }
  }

  // NOUVELLES MÉTHODES À AJOUTER

  // 1. Obtenir les membres d'une communauté
  Future<List<MemberModel>> getCommunityMembers(int communityId) async {
    try {
      isLoading.value = true;
      error.value = '';
      final members = await _communityService.getCommunityMembers(communityId);
      currentMembers.assignAll(members);
      return members;
    } catch (e) {
      error.value = 'Erreur de chargement des membres: $e';
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  // 2. Générer un nouveau code d'invitation
  Future<InviteModel?> generateInviteCode(int communityId) async {
    try {
      isLoading.value = true;
      error.value = '';
      final invite = await _communityService.generateInviteCode(communityId);
      if (invite != null &&
          currentCommunity.value?.community_id == communityId) {
        // Utiliser copyWith avec les bons noms
        currentCommunity.value = currentCommunity.value!.copyWith(
          invite_code: invite.inviteCode,
        );
      }
      return invite;
    } catch (e) {
      error.value = 'Erreur de génération du code: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // 3. Modifier le rôle d'un membre
  Future<bool> updateMemberRole({
    required int communityId,
    required int memberId,
    required String role,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      final success = await _communityService.updateMemberRole(
        communityId: communityId,
        memberId: memberId,
        role: role,
      );
      if (success) {
        // Mettre à jour la liste locale des membres
        final index = currentMembers.indexWhere((m) => m.id == memberId);
        if (index != -1) {
          final updatedMember = MemberModel(
            id: currentMembers[index].id,
            email: currentMembers[index].email,
            nom: currentMembers[index].nom,
            prenom: currentMembers[index].prenom,
            role: role,
            joinedAt: currentMembers[index].joinedAt,
          );
          currentMembers[index] = updatedMember;
        }
      }
      return success;
    } catch (e) {
      error.value = 'Erreur de modification du rôle: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 4. Retirer un membre
  Future<bool> removeMember({
    required int communityId,
    required int memberId,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      final success = await _communityService.removeMember(
        communityId: communityId,
        memberId: memberId,
      );
      if (success) {
        // Retirer le membre de la liste locale
        currentMembers.removeWhere((m) => m.id == memberId);
        // Mettre à jour le compteur de membres
        if (currentCommunity.value != null) {
          currentCommunity.value = currentCommunity.value!.copyWith(
            members_count: currentCommunity.value!.members_count - 1,
          );
        }
      }
      return success;
    } catch (e) {
      error.value = 'Erreur de retrait du membre: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 5. Mettre à jour une communauté
  Future<bool> updateCommunity({
    required int communityId,
    String? nom,
    String? description,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      final success = await _communityService.updateCommunity(
        communityId: communityId,
        nom: nom,
        description: description,
      );
      if (success && currentCommunity.value?.community_id == communityId) {
        // Utiliser copyWith
        currentCommunity.value = currentCommunity.value!.copyWith(
          nom: nom,
          description: description,
        );

        // Mettre à jour dans la liste des communautés
        final index = communities.indexWhere(
          (c) => c.community_id == communityId,
        );
        if (index != -1) {
          communities[index] = currentCommunity.value!;
        }
      }
      return success;
    } catch (e) {
      error.value = 'Erreur de mise à jour: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 6. Effacer les données du controller
  void clearData() {
    communities.clear();
    currentCommunity.value = null;
    currentMembers.clear();
    error.value = '';
  }

  // 7. Obtenir les statistiques des communautés
  Map<String, int> getCommunityStats() {
    int totalMembers = 0;
    // int totalProjects = 0;
    int adminCount = 0;
    int responsableCount = 0;
    int membreCount = 0;

    for (final member in currentMembers) {
      totalMembers++;
      switch (member.role.toUpperCase()) {
        case 'ADMIN':
          adminCount++;
          break;
        case 'RESPONSABLE':
          responsableCount++;
          break;
        case 'MEMBRE':
          membreCount++;
          break;
      }
    }

    return {
      'totalMembers': totalMembers,
      'totalProjects': currentCommunity.value?.projects_count ?? 0,
      'adminCount': adminCount,
      'responsableCount': responsableCount,
      'membreCount': membreCount,
    };
  }

  // 8. Vérifier si l'utilisateur est admin
  bool isCurrentUserAdmin() {
    return currentCommunity.value?.role == 'ADMIN';
  }

  // 9. Vérifier si l'utilisateur peut gérer les membres
  bool canManageMembers() {
    return currentCommunity.value?.role == 'ADMIN';
  }

  // 10. Rechercher un membre par email ou nom
  List<MemberModel> searchMembers(String query) {
    if (query.isEmpty) return currentMembers.toList();

    final lowercaseQuery = query.toLowerCase();
    return currentMembers.where((member) {
      return member.email.toLowerCase().contains(lowercaseQuery) ||
          member.nom.toLowerCase().contains(lowercaseQuery) ||
          member.prenom.toLowerCase().contains(lowercaseQuery) ||
          member.fullName.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
