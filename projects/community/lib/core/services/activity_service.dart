// ignore_for_file: avoid_print

import 'package:community/core/services/api_service.dart';
import 'package:community/data/models/activity_model.dart';
import 'package:get/get.dart';

class ActivityService {
  final ApiService _apiService = Get.find();

  Future<List<ActivityModel>> getCommunityActivities({
    required int communityId,
    int limit = 50,
  }) async {
    try {
      final response = await _apiService.get(
        '/communities/$communityId/activities?limit=$limit',
      );

      if (response.success) {
        final activities = (response.data['activities'] as List)
            .map((item) => ActivityModel.fromJson(item))
            .toList();
        return activities;
      }
      return [];
    } catch (e) {
      print('Erreur ActivityService.getCommunityActivities: $e');
      return [];
    }
  }

  Future<List<ActivityModel>> getProjectActivities({
    required int communityId,
    required int projectId,
    int limit = 50,
  }) async {
    // Utilise l'endpoint général de la communauté pour l'instant
    return await getCommunityActivities(communityId: communityId, limit: limit);
  }
}
