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
  final bool isLiked; 

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
    this.isLiked = false, 
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
      isLiked: json['isLiked'] ?? false, 
    );
  }

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
      'isLiked': isLiked, 
    };
  }

  // to update riverpod state
  ResponsePostModel copyWith({
    String? postId,
    String? content,
    String? mediaUrls,
    int? likeCount,
    int? commentCount,
    int? shareCount,
    DateTime? createdDate,
    String? authorId,
    String? authorName,
    bool? isLiked,
  }) {
    return ResponsePostModel(
      postId: postId ?? this.postId,
      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      createdDate: createdDate ?? this.createdDate,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}