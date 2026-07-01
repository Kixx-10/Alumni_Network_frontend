import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/action/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentTile extends StatefulWidget {
  final CommentModel comment;
  final int depth;
  final void Function(CommentModel comment) onReplyTap;

  const CommentTile({
    super.key,
    required this.comment,
    this.depth = 0,
    required this.onReplyTap,
  });

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  bool _showReplies = true;
  static const int _maxIndentDepth = 3;

  String _resolveAvatarUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) return '';
    if (rawUrl.startsWith('http')) return rawUrl;
    final String baseUrl = 'http://${ApiClient.ipAddress}';
    return '$baseUrl$rawUrl';
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;
    final bool hasReplies = comment.replies.isNotEmpty;

    final effectiveDepth =
        widget.depth > _maxIndentDepth ? _maxIndentDepth : widget.depth;
    final double indentWidth = effectiveDepth * 32.w;


    final String resolvedAvatarUrl =
        _resolveAvatarUrl(comment.userProfileImage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: indentWidth, bottom: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: comment.isReply ? 14.r : 18.r,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: resolvedAvatarUrl.isNotEmpty
                    ? NetworkImage(resolvedAvatarUrl)
                    : const AssetImage('assets/images/profile.jpg')
                        as ImageProvider,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      comment.content,
                      style: TextStyle(fontSize: 13.sp, height: 1.3),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          _formatTimeAgo(comment.createdDate),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        GestureDetector(
                          onTap: () => widget.onReplyTap(comment),
                          child: Text(
                            'Reply',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        if (hasReplies) ...[
                          SizedBox(width: 14.w),
                          GestureDetector(
                            onTap: () {
                              setState(
                                  () => _showReplies = !_showReplies);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  _showReplies
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 14.sp,
                                  color: Colors.grey.shade600,
                                ),
                                Text(
                                  '${comment.replies.length} ${comment.replies.length == 1 ? 'reply' : 'replies'}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Recursive replies
        if (hasReplies && _showReplies)
          ...comment.replies.map(
            (reply) => CommentTile(
              comment: reply,
              depth: widget.depth + 1,
              onReplyTap: widget.onReplyTap,
            ),
          ),
      ],
    );
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    }
    return 'Just now';
  }
}