import 'package:community/data/models/invite_model.dart';
import 'package:community/data/models/member_model.dart';
import 'package:get/get.dart';
import 'package:community/data/models/community_model.dart';
import 'api_service.dart';

class CommunityService extends GetxService {
  final ApiService _apiService = Get.find();

  Future<List<CommunityModel>> getUserCommunities() async {
    final response = await _apiService.get('/communities');
    if (response.success) {
      final communities = (response.data['communities'] as List)
          .map((item) => CommunityModel.fromJson(item))
          .toList();
      return communities;
    }
    return [];
  }

  Future<CommunityModel?> createCommunity({
    required String nom,
    required String description,
  }) async {
    final response = await _apiService.post('/communities', {
      'nom': nom,
      'description': description,
    });

    if (response.success) {
      return CommunityModel.fromJson(response.data);
    }
    return null;
  }

  Future<bool> joinCommunity(String inviteCode) async {
    final response = await _apiService.post('/communities/join', {
      'invite_code': inviteCode,
    });
    return response.success;
  }

  Future<CommunityModel?> getCommunityDetails(int communityId) async {
    final response = await _apiService.get('/communities/$communityId');
    if (response.success) {
      return CommunityModel.fromJson(response.data['community']);
    }
    return null;
  }

  Future<bool> updateCommunity({
    required int communityId,
    String? nom,
    String? description,
  }) async {
    final Map<String, dynamic> data = {};
    if (nom != null) data['nom'] = nom;
    if (description != null) data['description'] = description;

    final response = await _apiService.put('/communities/$communityId', data);
    return response.success;
  }

  Future<List<MemberModel>> getCommunityMembers(int communityId) async {
    final response = await _apiService.get('/communities/$communityId/members');
    if (response.success) {
      final members = (response.data['members'] as List)
          .map((item) => MemberModel.fromJson(item))
          .toList();
      return members;
    }
    return [];
  }

  Future<InviteModel?> generateInviteCode(int communityId) async {
    final response = await _apiService.post(
      '/communities/$communityId/members',
      {},
    );
    if (response.success) {
      return InviteModel.fromJson(response.data);
    }
    return null;
  }

  Future<bool> updateMemberRole({
    required int communityId,
    required int memberId,
    required String role,
  }) async {
    final response = await _apiService.put(
      '/communities/$communityId/members/$memberId',
      {'role': role},
    );
    return response.success;
  }

  Future<bool> removeMember({
    required int communityId,
    required int memberId,
  }) async {
    final response = await _apiService.delete(
      '/communities/$communityId/members/$memberId',
    );
    return response.success;
  }
}
