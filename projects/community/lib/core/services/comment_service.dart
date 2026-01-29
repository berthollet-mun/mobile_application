import 'package:community/data/models/comment_model.dart';
import 'package:get/get.dart';
import 'api_service.dart';

class CommentService extends GetxService {
  final ApiService _apiService = Get.find();

  Future<List<CommentModel>> getTaskComments({
    required int communityId,
    required int projectId,
    required int taskId,
  }) async {
    final response = await _apiService.get(
      '/communities/$communityId/projects/$projectId/tasks/$taskId/comments',
    );

    if (response.success) {
      final comments = (response.data['comments'] as List)
          .map((item) => CommentModel.fromJson(item))
          .toList();
      return comments;
    }
    return [];
  }

  Future<CommentModel?> addComment({
    required int communityId,
    required int projectId,
    required int taskId,
    required String content,
  }) async {
    final response = await _apiService.post(
      '/communities/$communityId/projects/$projectId/tasks/$taskId/comments',
      {'content': content},
    );

    if (response.success) {
      return CommentModel.fromJson(response.data);
    }
    return null;
  }

  Future<bool> updateComment({
    required int communityId,
    required int projectId,
    required int taskId,
    required int commentId,
    required String content,
  }) async {
    final response = await _apiService.put(
      '/communities/$communityId/projects/$projectId/tasks/$taskId/comments/$commentId',
      {'content': content},
    );
    return response.success;
  }

  Future<bool> deleteComment({
    required int communityId,
    required int projectId,
    required int taskId,
    required int commentId,
  }) async {
    final response = await _apiService.delete(
      '/communities/$communityId/projects/$projectId/tasks/$taskId/comments/$commentId',
    );
    return response.success;
  }
}
