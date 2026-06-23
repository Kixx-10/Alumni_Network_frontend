import 'dart:developer' as developer;
import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/action/like_reques_model.dart';
import 'package:alumni_network/data/repository/like_toggle_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'like_toggle_notifier.g.dart';

@Riverpod(keepAlive: true)
class LikeToggleNotifier extends _$LikeToggleNotifier {
  late final LikeToggleRepository _repository;

  @override
  AsyncValue<void> build() {
    _repository = LikeToggleRepository(ApiClient());
    return const AsyncData(null);
  }

  Future<bool> toggleLike(LikeRequestModel likeModel) async {
    bool isSuccess = false;
  
    try {
      developer.log('❤️ Toggling Like for Post: ${likeModel.postId}', name: 'LIKE_TOGGLE_NOTIFIER');
      
      final response = await _repository.toggleLike(likeModel);
      final String message = response.data['message'] ?? "Success";
      
      developer.log('🎉 Like Response Received: $message', name: 'LIKE_TOGGLE_NOTIFIER');
      isSuccess = true;
    } catch (e, stackTrace) {
      developer.log('❌ Like Toggle Failed API Error: $e', name: 'LIKE_TOGGLE_NOTIFIER', error: e, stackTrace: stackTrace);
      isSuccess = false;
    }

    return isSuccess;
  }
}