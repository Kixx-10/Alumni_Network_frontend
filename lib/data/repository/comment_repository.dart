import 'package:alumni_network/core/constants/api_endpoints.dart';
import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/action/comment_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CommentRepository {
  final ApiClient _apiClient;

  CommentRepository(this._apiClient);
  Future<CommentModel> createComment(
    WriteCommentModel commentModel,
    String jwtToken,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndPoints.createComment,
        data: commentModel.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer ${jwtToken.trim()}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> commentData =
            response.data['data'] as Map<String, dynamic>;
        return CommentModel.fromJson(commentData);
      }

      throw Exception('Unexpected response: ${response.statusCode}');
    } on DioException catch (e) {
      debugPrint('======== CREATE COMMENT ERROR ========');
      debugPrint('Status Code : ${e.response?.statusCode}');
      debugPrint('Response    : ${e.response?.data}');
      debugPrint('=======================================');
      throw e.response?.data?['message'] ?? 'Failed to post comment';
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CommentModel>> fetchPostComments(String postId) async {
  
    try {
      final response = await _apiClient.get(
        ApiEndPoints.getPostComments(postId),
      );

      if (response.statusCode == 200 && response.data != null) {
        // Backend ServiceResponse<List<ReadCommentDTO>> structure
        final List<dynamic> commentDataList =
            response.data['data'] as List<dynamic>? ?? [];
        return commentDataList
            .map((json) => CommentModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      debugPrint('======== FETCH COMMENTS ERROR ========');
      debugPrint('Status Code : ${e.response?.statusCode}');
      debugPrint('Response    : ${e.response?.data}');
      debugPrint('=======================================');
      throw e.response?.data?['message'] ?? 'Failed to fetch comments';
    } catch (e) {
      rethrow;
    }
  }
}
