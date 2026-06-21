class ResponsePostModel {
  final String postId;
  final String? content; 
  final String? mediaUrls;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final DateTime createdDate;
  final String authorId;
  final String authorName;

  ResponsePostModel({
    required this.postId,
    this.content, 
    this.mediaUrls,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.createdDate,
    required this.authorId,
    required this.authorName,
  });

  factory ResponsePostModel.fromJson(Map<String, dynamic> json) {
    return ResponsePostModel(
      postId: json['postId'] ?? '',
      content: json['content'], 
      mediaUrls: json['mediaUrls'], 
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      shareCount: json['shareCount'] ?? 0,
      createdDate: json['createdDate'] != null 
          ? DateTime.parse(json['createdDate']) 
          : DateTime.now(),
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? 'Unknown Author',
    );
  }
//need for offline to storage local storage
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'content': content, 
      'mediaUrls': mediaUrls,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'createdDate': createdDate.toIso8601String(),
      'authorId': authorId,
      'authorName': authorName,
    };
  }
}