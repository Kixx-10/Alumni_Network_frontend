import 'package:alumni_network/core/constants/api_endpoints.dart';
import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/profile/response_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ResponseProfileRepository {
  final ApiClient _apiClient;

  ResponseProfileRepository(this._apiClient);
  Future<ResponseProfileModel> fetchMyProfile(String jwtToken) async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndPoints.getMyProfile,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${jwtToken.trim()}',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        // Backend ServiceResponse<ResponseProfileDTO> structure:
        // { "isSuccess": true, "message": "...", "data": { ...profile fields } }
        final Map<String, dynamic> profileData =
            response.data['data'] as Map<String, dynamic>;
        return ResponseProfileModel.fromJson(profileData);
      }

      throw Exception('Unexpected response: ${response.statusCode}');
    } on DioException catch (e) {
      debugPrint('======== FETCH MY PROFILE ERROR ========');
      debugPrint('Status Code : ${e.response?.statusCode}');
      debugPrint('Response    : ${e.response?.data}');
      debugPrint('========================================');
      throw e.response?.data?['message'] ?? 'Failed to fetch profile from server';
    } catch (e) {
      rethrow;
    }
  }
}
