import 'package:community/data/models/kanban_model.dart';
import 'package:community/data/models/task_model.dart';
import 'package:get/get.dart';
import 'api_service.dart';

class TaskService extends GetxService {
  final ApiService _apiService = Get.find();

  Future<KanbanModel?> getKanbanTasks({
    required int communityId,
    required int projectId,
  }) async {
    final response = await _apiService.get(
      '/communities/$communityId/projects/$projectId/tasks',
    );

    if (response.success) {
      return KanbanModel.fromJson(response.data['kanban']);
    }
    return null;
  }

  Future<TaskModel?> createTask({
    required int communityId,
    required int projectId,
    required String titre,
    required String description,
    int? assignedTo,
    String? dueDate,
  }) async {
    final Map<String, dynamic> data = {
      'titre': titre,
      'description': description,
    };

    if (assignedTo != null) data['assigned_to'] = assignedTo;
    if (dueDate != null) data['due_date'] = dueDate;

    final response = await _apiService.post(
      '/communities/$communityId/projects/$projectId/tasks',
      data,
    );

    if (response.success) {
      return TaskModel.fromJson(response.data);
    }
    return null;
  }

  Future<TaskModel?> getTaskDetails({
    required int communityId,
    required int projectId,
    required int taskId,
  }) async {
    final response = await _apiService.get(
      '/communities/$communityId/projects/$projectId/tasks/$taskId',
    );

    if (response.success) {
      return TaskModel.fromJson(response.data['task']);
    }
    return null;
  }

  Future<bool> updateTask({
    required int communityId,
    required int projectId,
    required int taskId,
    String? titre,
    String? description,
    int? assignedTo,
    String? dueDate,
  }) async {
    final Map<String, dynamic> data = {};
    if (titre != null) data['titre'] = titre;
    if (description != null) data['description'] = description;
    if (assignedTo != null) data['assigned_to'] = assignedTo;
    if (dueDate != null) data['due_date'] = dueDate;

    final response = await _apiService.put(
      '/communities/$communityId/projects/$projectId/tasks/$taskId',
      data,
    );
    return response.success;
  }

  Future<bool> updateTaskStatus({
    required int communityId,
    required int projectId,
    required int taskId,
    required String status,
  }) async {
    final response = await _apiService.patch(
      '/communities/$communityId/projects/$projectId/tasks/$taskId/status',
      {'status': status},
    );
    return response.success;
  }

  Future<bool> deleteTask({
    required int communityId,
    required int projectId,
    required int taskId,
  }) async {
    final response = await _apiService.delete(
      '/communities/$communityId/projects/$projectId/tasks/$taskId',
    );
    return response.success;
  }
}
