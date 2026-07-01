class CommentModel {
  final String commentId;
  final String postId;
  final String content;
  final DateTime createdDate;
  final DateTime? updatedDate;
  final String userId;
  final String userName;
  final String? userProfileImage;
  final String? parentCommentId;
  final List<CommentModel> replies; 

  const CommentModel({
    required this.commentId,
    required this.postId,
    required this.content,
    required this.createdDate,
    this.updatedDate,
    required this.userId,
    required this.userName,
    this.userProfileImage,
    this.parentCommentId,
    this.replies = const [],
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['commentId'] as String? ?? '',
      postId: json['postId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'] as String)
          : DateTime.now(),
      updatedDate: json['updatedDate'] != null
          ? DateTime.parse(json['updatedDate'] as String)
          : null,
      userId: json['userId'] as String? ?? '',
      userName: json['userName'] as String? ?? 'Unknown User',
      userProfileImage: json['userProfileImage'] as String?,
      parentCommentId: json['parentCommentId'] as String?,
      replies: json['replies'] != null
          ? (json['replies'] as List<dynamic>)
              .map((r) => CommentModel.fromJson(r as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  // ── Model → JSON ────────────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'postId': postId,
      'content': content,
      'createdDate': createdDate.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'userId': userId,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'parentCommentId': parentCommentId,
      'replies': replies.map((r) => r.toJson()).toList(),
    };
  }
  CommentModel copyWith({
    String? commentId,
    String? postId,
    String? content,
    DateTime? createdDate,
    DateTime? updatedDate,
    String? userId,
    String? userName,
    String? userProfileImage,
    String? parentCommentId,
    List<CommentModel>? replies,
  }) {
    return CommentModel(
      commentId: commentId ?? this.commentId,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      replies: replies ?? this.replies,
    );
  }
  bool get isReply => parentCommentId != null;
}


class WriteCommentModel {
  final String postId;
  final String content;
  final String? parentCommentId; 

  const WriteCommentModel({
    required this.postId,
    required this.content,
    this.parentCommentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'content': content,
      'parentCommentId': parentCommentId,
    };
  }
}
