import 'package:community/core/services/comment_service.dart';
import 'package:community/data/models/comment_model.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {
  final CommentService _commentService = Get.find();
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> loadTaskComments({
    required int communityId,
    required int projectId,
    required int taskId,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final commentsList = await _commentService.getTaskComments(
        communityId: communityId,
        projectId: projectId,
        taskId: taskId,
      );

      comments.assignAll(commentsList);
    } catch (e) {
      error.value = 'Erreur de chargement des commentaires: $e';
      comments.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<CommentModel?> addComment({
    required int communityId,
    required int projectId,
    required int taskId,
    required String content,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final comment = await _commentService.addComment(
        communityId: communityId,
        projectId: projectId,
        taskId: taskId,
        content: content,
      );

      if (comment != null) {
        comments.insert(
          0,
          comment,
        ); // Ajouter au début pour afficher le plus récent en premier
      }

      return comment;
    } catch (e) {
      error.value = 'Erreur d\'ajout de commentaire: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateComment({
    required int communityId,
    required int projectId,
    required int taskId,
    required int commentId,
    required String content,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final success = await _commentService.updateComment(
        communityId: communityId,
        projectId: projectId,
        taskId: taskId,
        commentId: commentId,
        content: content,
      );

      if (success) {
        final index = comments.indexWhere((c) => c.id == commentId);
        if (index != -1) {
          // ✅ Utiliser copyWith au lieu de créer un nouveau CommentModel
          comments[index] = comments[index].copyWith(
            content: content,
            updated_at: DateTime.now(),
          );
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

  Future<bool> deleteComment({
    required int communityId,
    required int projectId,
    required int taskId,
    required int commentId,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final success = await _commentService.deleteComment(
        communityId: communityId,
        projectId: projectId,
        taskId: taskId,
        commentId: commentId,
      );

      if (success) {
        comments.removeWhere((c) => c.id == commentId);
      }

      return success;
    } catch (e) {
      error.value = 'Erreur de suppression: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearComments() {
    comments.clear();
    error.value = '';
  }

  bool canEditComment(CommentModel comment, int currentUserId) {
    // L'utilisateur peut modifier son propre commentaire
    // Pour simplifier, nous vérifierons via l'email (à adapter selon l'implémentation)
    // Dans une vraie app, vous auriez l'ID utilisateur dans le commentaire
    return comment.email ==
        'current_user@example.com'; // À remplacer par la logique réelle
  }

  bool canDeleteComment(CommentModel comment, String userRole) {
    // ADMIN et RESPONSABLE peuvent supprimer tous les commentaires
    return userRole == 'ADMIN' || userRole == 'RESPONSABLE';
  }
}
