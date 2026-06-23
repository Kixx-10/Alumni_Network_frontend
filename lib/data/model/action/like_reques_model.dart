class LikeRequestModel {
  final String postId;
  final String userId;

  LikeRequestModel({required this.postId, required this.userId});
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
    };
  }
}