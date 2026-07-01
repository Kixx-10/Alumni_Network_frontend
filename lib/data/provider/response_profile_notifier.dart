import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/profile/response_profile_model.dart';
import 'package:alumni_network/data/provider/auth_provider.dart';
import 'package:alumni_network/data/repository/response_profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'response_profile_notifier.g.dart';

@riverpod
class ResponseProfileNotifier extends _$ResponseProfileNotifier {
  late final ResponseProfileRepository _repository;

  @override
  FutureOr<ResponseProfileModel> build() async {
    _repository = ResponseProfileRepository(ApiClient());
    return await fetchMyProfile();
  }

  // ── Profile data
  Future<ResponseProfileModel> fetchMyProfile() async {
    state = const AsyncLoading();
    try {
      final String? token = await ref.read(tokenStorageProvider).getToken();

      if (token == null || token.trim().isEmpty) {
        throw Exception('Authentication token not found. Please login again.');
      }

      final profile = await _repository.fetchMyProfile(token.trim());
      state = AsyncValue.data(profile);
      return profile;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  // ── Pull-to-refresh =Post refreshPosts() 
  Future<void> refreshProfile() async {
    await fetchMyProfile();
  }

  // ── Local state update (Avatar ပြောင်းသောအခါ API မခေါ်ဘဲ UI update) ─
  //same Post updatePostLikeStatus
  void updateAvatarLocally(String newAvatarUrl) {
    if (state.hasValue) {
      state = AsyncValue.data(
        state.value!.copyWith(avatarUrl: newAvatarUrl),
      );
    }
  }
}
