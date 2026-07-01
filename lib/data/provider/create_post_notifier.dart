import 'dart:io';
import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/post/create_post_model.dart'; 
import 'package:alumni_network/data/provider/auth_provider.dart';       
import 'package:alumni_network/data/repository/create_post_repositroy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_post_notifier.g.dart'; 

@riverpod
class CreatePostNotifier extends _$CreatePostNotifier {
  late final PostRepository _repository;

 @override
AsyncValue<void> build() {
  _repository = PostRepository(ApiClient()); 
  return const AsyncData(null); 
}
  Future<bool> submitPost({
     String? content,
    required List<File> pickedImages,
  }) async {
    bool isSuccess = false;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      String? finalMediaUrls;
      final String? token = await ref.read(tokenStorageProvider).getToken();
      if (token == null) {
        throw Exception("Authentication token not found. Please login again.");
      }
      if (pickedImages.isNotEmpty) {
       finalMediaUrls = await _repository.uploadMultipleImages(pickedImages, token);
      }

      final postModel = CreatePostModel(
        content: content,
        mediaUrls: finalMediaUrls,
      );
      await _repository.createPost(postModel, token);
      isSuccess = true;
    });

    return isSuccess;
  }
}