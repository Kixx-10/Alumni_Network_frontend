import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/post/response_post_model.dart';
import 'package:alumni_network/data/repository/response_post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart'; 

part 'response_post_notifier.g.dart'; 

@riverpod
class ResponsePostNotifier extends _$ResponsePostNotifier {
  late final ResponsePostRepository _repository;

  @override
  FutureOr<List<ResponsePostModel>> build() async {
    _repository = ResponsePostRepository(ApiClient());
    // when app is start to see all post
    return await fetchPosts();
  }
  Future<List<ResponsePostModel>> fetchPosts() async {
    state = const AsyncLoading();
    try {
      final posts = await _repository.fetchAllPosts();
      state = AsyncValue.data(posts);
      return posts;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }
  // if user want to refresh
  Future<void> refreshPosts() async {
    await fetchPosts();
  }
  
  void updatePostLikeStatus(String postId, {required bool isLiked}) {
    if (state.hasValue) {
      final currentPosts = state.value!;
      
      final updatedPosts = currentPosts.map((post) {
        if (post.postId == postId) {

          int newLikeCount = isLiked ? post.likeCount + 1 : post.likeCount - 1;
          if (newLikeCount < 0) newLikeCount = 0; 
          
          return post.copyWith(
            isLiked: isLiked,
            likeCount: newLikeCount,
          );
        }
        return post;
      }).toList();
      state = AsyncValue.data(updatedPosts);
    }
  }
}