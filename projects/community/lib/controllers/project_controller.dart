import 'package:community/core/services/project_service.dart';
import 'package:community/data/models/project_model.dart';
import 'package:get/get.dart';

class ProjectController extends GetxController {
  final ProjectService _projectService = Get.find();

  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final Rx<ProjectModel?> currentProject = Rx<ProjectModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool showArchived = false.obs;

  void clearCurrentProject() {
    currentProject.value = null;
  }

  Future<void> loadProjects(int communityId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final projectsList = await _projectService.getProjects(
        communityId: communityId,
        includeArchived: showArchived.value,
      );

      projects.assignAll(projectsList);
    } catch (e) {
      error.value = 'Erreur de chargement des projets: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<ProjectModel?> createProject({
    required int communityId,
    required String nom,
    required String description,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final project = await _projectService.createProject(
        communityId: communityId,
        nom: nom,
        description: description,
      );

      if (project != null) {
        projects.add(project);
        currentProject.value = project;
        return project;
      }
      return null;
    } catch (e) {
      error.value = 'Erreur de création du projet: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setCurrentProject(ProjectModel project) async {
    currentProject.value = project;
  }

  Future<void> refreshCurrentProject(int communityId) async {
    if (currentProject.value != null) {
      try {
        final project = await _projectService.getProjectDetails(
          communityId: communityId,
          projectId: currentProject.value!.id,
        );

        if (project != null) {
          currentProject.value = project;
        }
      } catch (e) {
        error.value = 'Erreur de rafraîchissement: $e';
      }
    }
  }

  Future<bool> updateProject({
    required int communityId,
    required int projectId,
    String? nom,
    String? description,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final success = await _projectService.updateProject(
        communityId: communityId,
        projectId: projectId,
        nom: nom,
        description: description,
      );

      if (success && currentProject.value?.id == projectId) {
        await refreshCurrentProject(communityId);
      }

      return success;
    } catch (e) {
      error.value = 'Erreur de mise à jour: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> archiveProject({
    required int communityId,
    required int projectId,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final success = await _projectService.archiveProject(
        communityId: communityId,
        projectId: projectId,
      );

      if (success) {
        projects.removeWhere((project) => project.id == projectId);
        if (currentProject.value?.id == projectId) {
          currentProject.value = null;
        }
      }

      return success;
    } catch (e) {
      error.value = 'Erreur d\'archivage: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleShowArchived() {
    showArchived.value = !showArchived.value;
  }

  List<ProjectModel> get activeProjects {
    return projects.where((project) => !project.isArchived).toList();
  }

  List<ProjectModel> get archivedProjects {
    return projects.where((project) => project.isArchived).toList();
  }
}
