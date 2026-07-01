// lib/data/provider/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alumni_network/core/network/token_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; 
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart'; 

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

// check there is token or no from flash page
final authCheckProvider = FutureProvider<bool>((ref) async {
  final storage = ref.watch(tokenStorageProvider);
  final token = await storage.getToken();
  return token != null && token.isNotEmpty;
});

@riverpod
Future<String> currentUserId(Ref ref) async {
  final storage = ref.watch(tokenStorageProvider);
  final token = await storage.getToken();
  
  if (token != null && token.isNotEmpty) {
    if (JwtDecoder.isExpired(token)) return '';

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final userId = decodedToken['id'] ?? 
                   decodedToken['Id'] ??
                   decodedToken['userId'] ??
                   decodedToken['UserId'] ??
                   decodedToken['nameid'] ?? 
                   decodedToken['sub'] ?? 
                   decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ??
                   '';
    return userId.toString();
  }

  return '';
}
