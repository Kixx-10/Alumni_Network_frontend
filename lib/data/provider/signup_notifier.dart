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
    
    String? token;
    if (response.data != null && response.data['data'] != null) {
      if (response.data['data']['token'] != null) {
        token = response.data['data']['token'].toString();
      }
    }
    if (token != null && token.isNotEmpty) {
      await ref.read(tokenStorageProvider).saveToken(token);
      
      developer.log(
        '🔑 Backend Token Received & Saved',
        name: 'AUTH_NOTIFIER',
        error: token,
      );
      ref.invalidate(authCheckProvider);
    } else {
      throw Exception("Registration succeeded, but Token was not found in response.");
    }
  });
}
}