import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/post/response_post_model.dart';
import 'package:alumni_network/data/repository/response_post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'response_post_notifier.g.dart';

@riverpod
class ResponsePostNotifier extends _$ResponsePostNotifier {
  ResponsePostRepository get _repository =>
      ResponsePostRepository(ApiClient());

  @override
  FutureOr<List<ResponsePostModel>> build() async {
    return await _repository.fetchAllPosts();
  }

  Future<void> refreshPosts() async {
    ref.invalidateSelf();
    await future;
  }

  void updatePostLikeStatus(String postId, {required bool isLiked}) {
    if (!state.hasValue) return;
    final updatedPosts = state.value!.map((post) {
      if (post.postId == postId) {
        int newLikeCount = isLiked ? post.likeCount + 1 : post.likeCount - 1;
        if (newLikeCount < 0) newLikeCount = 0;
        return post.copyWith(isLiked: isLiked, likeCount: newLikeCount);
      }
      return post;
    }).toList();
    state = AsyncValue.data(updatedPosts);
  }

  void incrementCommentCount(String postId) {
    if (!state.hasValue) return;
    final updatedPosts = state.value!.map((post) {
      if (post.postId == postId) {
        return post.copyWith(commentCount: post.commentCount + 1);
      }
      return post;
    }).toList();
    state = AsyncValue.data(updatedPosts);
  }
}