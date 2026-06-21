import 'dart:developer' as developer;
import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/registration/signup_model.dart';
import 'package:alumni_network/data/provider/auth_provider.dart';
import 'package:alumni_network/data/repository/registration_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_notifier.g.dart';

@riverpod
class SignupNotifier extends _$SignupNotifier { 
  late final RegistrationRepository _repository; 

  @override
  AsyncValue<void> build() {
    _repository = RegistrationRepository(ApiClient()); 
    return const AsyncData(null); 
  }

  Future<void> signUp(SignUpModel model) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final response = await _repository.signUp(model);
      final backendData = response.data['data']; 
      
      if (backendData != null && backendData['token'] != null) {
       final String token = backendData['token'].toString();
        await ref.read(tokenStorageProvider).saveToken(token);
        developer.log(
          '🔑 Backend Token Received',
          name: 'AUTH_NOTIFIER',
          error: token,
        );
        //refresh provider
        ref.invalidate(authCheckProvider);
        
      } else {
        final errorMessage = response.data['message'] ?? "Token missing from server";
        throw Exception(errorMessage);
      }
    });
  }
}
