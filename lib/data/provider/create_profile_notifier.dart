import 'dart:io';
import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/profile/create_profile_model.dart';
import 'package:alumni_network/data/provider/auth_provider.dart';
import 'package:alumni_network/data/repository/create_profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_profile_notifier.g.dart';

@riverpod
class CreateProfileNotifier extends _$CreateProfileNotifier {
  late final CreateProfileRepository _repository;

  @override
  AsyncValue<void> build() {
    _repository = CreateProfileRepository(ApiClient());
    return const AsyncData(null);
  }

  Future<bool> submitProfile({
    required String fullName,
    required String? section,
    required String? university,
    required int? graduationYear,
    required String? department,
    required String? company,
    required String? jobTitle,
    File? pickedImage,
  }) async {
    state = const AsyncLoading();
    bool isSuccess = false;

    state = await AsyncValue.guard(() async {
      final String? token = await ref.read(tokenStorageProvider).getToken();

      if (token == null || token.trim().isEmpty) {
        throw Exception(
            'Authentication token not found. Please login again.');
      }
      final cleanToken = token.trim();

      String finalAvatarUrl = '';
      if (pickedImage != null) {
        final String? uploadedUrl =
            await _repository.uploadProfileImage(pickedImage, cleanToken);
        if (uploadedUrl != null) {
          finalAvatarUrl = uploadedUrl;
        }
      }

      final profileModel = CreateProfileModel(
        fullName: fullName,
        avatarUrl: finalAvatarUrl,
        section: section,
        university: university,
        graduationYear: graduationYear,
        company: company,
        department: department,
        jobTitle: jobTitle,
      );

      await _repository.createProfile(profileModel, cleanToken);
      isSuccess = true;
    });

    return isSuccess;
  }
}
