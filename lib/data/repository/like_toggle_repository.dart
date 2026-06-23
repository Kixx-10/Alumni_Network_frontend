import 'package:alumni_network/core/constants/api_endpoints.dart';
import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/action/like_reques_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LikeToggleRepository {
  final ApiClient _apiClient;
  LikeToggleRepository(this. _apiClient);
  Future<Response>toggleLike(LikeRequestModel like)async{
    try{
      final response=await _apiClient.post(
        ApiEndPoints.toggleLike,
        data: like.toJson()
      );
      return response;
    }on DioException catch(e){
      debugPrint("Status Code: ${e.response?.statusCode}");
      debugPrint("Response Data: ${e.response?.data}");
      debugPrint("Message: ${e.message}");
      throw e.response?.data['message'] ?? "Something went wrong during toggle like";
    }
    catch(e){
      rethrow;
    }
  }
}