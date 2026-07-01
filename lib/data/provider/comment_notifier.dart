import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/action/comment_model.dart';
import 'package:alumni_network/data/provider/auth_provider.dart';
import 'package:alumni_network/data/repository/comment_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_notifier.g.dart';

@riverpod
class CommentNotifier extends _$CommentNotifier {
  late final CommentRepository _repository;

  @override
  FutureOr<List<CommentModel>> build(String postId) async {
    _repository = CommentRepository(ApiClient());
    return await fetchComments();
  }

  Future<List<CommentModel>> fetchComments() async {
    state = const AsyncLoading();
    try {
      final comments = await _repository.fetchPostComments(postId);
      state = AsyncValue.data(comments);
      return comments;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }

  Future<void> refreshComments() async {
    await fetchComments();
  }

  Future<bool> submitComment({
    required String content,
    String? parentCommentId,
  }) async {
    bool isSuccess = false;
    try {
      final String? token = await ref.read(tokenStorageProvider).getToken();
      if (token == null || token.trim().isEmpty) {
        throw Exception('Authentication token not found. Please login again.');
      }

      final writeModel = WriteCommentModel(
        postId: postId,
        content: content,
        parentCommentId: parentCommentId,
      );

      final newComment =
          await _repository.createComment(writeModel, token.trim());

      _addCommentToState(newComment, parentCommentId);
      isSuccess = true;
    } catch (e) {
      isSuccess = false;
    }
    return isSuccess;
  }

  void _addCommentToState(CommentModel newComment, String? parentCommentId) {
    if (!state.hasValue) return;

    final currentComments = List<CommentModel>.from(state.value!);

    if (parentCommentId == null) {
      currentComments.add(newComment);
      state = AsyncValue.data(currentComments);
    } else {
      final updatedComments = currentComments.map((comment) {
        if (comment.commentId == parentCommentId) {
          return comment.copyWith(
            replies: [...comment.replies, newComment],
          );
        }
        return comment;
      }).toList();
      state = AsyncValue.data(updatedComments);
    }
  }
}
