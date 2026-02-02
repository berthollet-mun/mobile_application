import 'package:community/data/models/project_model.dart';
import 'package:get/get.dart';
import 'api_service.dart';

class ProjectService extends GetxService {
  final ApiService _apiService = Get.find();

  Future<List<ProjectModel>> getProjects({
    required int communityId,
    bool includeArchived = false,
  }) async {
    final response = await _apiService.get(
      '/communities/$communityId/projects?include_archived=$includeArchived',
    );

    if (response.success) {
      final projects = (response.data['projects'] as List)
          .map((item) => ProjectModel.fromJson(item))
          .toList();
      return projects;
    }
    return [];
  }

  Future<ProjectModel?> createProject({
    required int communityId,
    required String nom,
    required String description,
  }) async {
    // 🔍 DEBUG
    print('=== CREATE PROJECT ===');
    print('Community ID: $communityId');
    print('Nom: $nom');
    print('Description: $description');
    print('URL: /communities/$communityId/projects');
    print('======================');

    final response = await _apiService.post(
      '/communities/$communityId/projects',
      {'nom': nom, 'description': description},
    );

    // 🔍 DEBUG
    print('=== CREATE PROJECT RESPONSE ===');
    print('Success: ${response.success}');
    print('Data: ${response.data}');
    print('Message: ${response.message}');
    print('===============================');

    if (response.success) {
      return ProjectModel.fromJson(response.data);
    }
    return null;
  }

  Future<ProjectModel?> getProjectDetails({
    required int communityId,
    required int projectId,
  }) async {
    final response = await _apiService.get(
      '/communities/$communityId/projects/$projectId',
    );

    if (response.success) {
      return ProjectModel.fromJson(response.data['project']);
    }
    return null;
  }

  Future<bool> updateProject({
    required int communityId,
    required int projectId,
    String? nom,
    String? description,
  }) async {
    final Map<String, dynamic> data = {};
    if (nom != null) data['nom'] = nom;
    if (description != null) data['description'] = description;

    final response = await _apiService.put(
      '/communities/$communityId/projects/$projectId',
      data,
    );
    return response.success;
  }

  Future<bool> archiveProject({
    required int communityId,
    required int projectId,
  }) async {
    final response = await _apiService.delete(
      '/communities/$communityId/projects/$projectId',
    );
    return response.success;
  }
}
