// ignore_for_file: file_names
import 'package:alumni_network/core/constants/api_endpoints.dart';
import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/post/response_post_model.dart'; 
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ResponsePostRepository {
  final ApiClient _apiClient;

  ResponsePostRepository(this._apiClient);

  Future<List<ResponsePostModel>> fetchAllPosts() async {
    try {
      final response = await _apiClient.get(ApiEndPoints.fetchPost);
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> postDataList = response.data['data'] ?? [];
        return postDataList.map((json) => ResponsePostModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint("======== FETCH ALL POSTS ERROR ========");
      debugPrint("Status Code: ${e.response?.statusCode}");
      debugPrint("Response Data: ${e.response?.data}");
      debugPrint("=======================================");
      throw e.response?.data['message'] ?? "Failed to fetch posts from server";
    } catch (e) {
      rethrow;
    }
  }
}