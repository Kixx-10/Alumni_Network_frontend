// ignore_for_file: file_names
import 'dart:io';
import 'package:alumni_network/core/constants/api_endpoints.dart';
import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/post/create_post_model.dart'; 
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PostRepository {
  final ApiClient _apiClient;

  PostRepository(this._apiClient);


  Future<String?> uploadMultipleImages(List<File> images, String jwtToken) async {
    try {
    
      _apiClient.dio.options.headers["Authorization"] = "Bearer $jwtToken";

      final formData = FormData();
      for (File file in images) {
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ));
      }

      final response = await _apiClient.dio.post(
        ApiEndPoints.uploadImages,
        data: formData,
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data['mediaUrls'] as String?;
      }
      return null;
    } on DioException catch (e) {
      debugPrint("======== BACKEND RAW UPLOAD ERROR ========");
      debugPrint("Status Code: ${e.response?.statusCode}");
      debugPrint("Response Data: ${e.response?.data}");
      debugPrint("==========================================");
      throw e.response?.data['message'] ?? "Something went wrong during image upload";
    } catch (e) {
      rethrow;
    }
  }
  Future<void> createPost(CreatePostModel postModel, String jwtToken) async {
    try {
      _apiClient.dio.options.headers["Authorization"] = "Bearer $jwtToken";
      final response = await _apiClient.dio.post(
        ApiEndPoints.createPost,
        data: postModel.toJson(),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to create post on server");
      }
    } on DioException catch (e) {
      debugPrint("======== BACKEND RAW CREATE POST ERROR ========");
      debugPrint("Status Code: ${e.response?.statusCode}");
      debugPrint("Response Data: ${e.response?.data}");
      debugPrint("=============================================");
      throw e.response?.data['message'] ?? "Something went wrong during post creation";
    } catch (e) {
      rethrow;
    }
  }
}