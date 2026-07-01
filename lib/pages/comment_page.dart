import 'package:alumni_network/data/model/action/comment_model.dart';
import 'package:alumni_network/data/model/post/response_post_model.dart';
import 'package:alumni_network/data/provider/comment_notifier.dart';
import 'package:alumni_network/widgets/comment_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentPage extends ConsumerStatefulWidget {
  final ResponsePostModel post;
  final String currentUserId;
  final VoidCallback? onCommentPosted;

  const CommentPage({
    super.key,
    required this.post,
    required this.currentUserId,
    this.onCommentPosted, 
  });
  static void show(
    BuildContext context,
    ResponsePostModel post,
    String currentUserId, {
    VoidCallback? onCommentPosted,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CommentPage(
        post: post,
        currentUserId: currentUserId,
        onCommentPosted: onCommentPosted,
      ),
    );
  }

  @override
  ConsumerState<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends ConsumerState<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  CommentModel? _replyingTo;

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _setReplyTarget(CommentModel comment) {
    setState(() => _replyingTo = comment);
    _focusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() => _replyingTo = null);
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    if (widget.currentUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please login to comment')),
      );
      return;
    }

    _commentController.clear();
    final replyTarget = _replyingTo;
    setState(() => _replyingTo = null);
    FocusScope.of(context).unfocus();

    final success = await ref
        .read(commentProvider(widget.post.postId).notifier)
        .submitComment(
          content: text,
          parentCommentId: replyTarget?.commentId,
        );

    if (success) {

      widget.onCommentPosted?.call();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Failed to post comment. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentState =
        ref.watch(commentProvider(widget.post.postId));

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              // Handle Bar
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              Text(
                'Comments',
                style:
                    TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5.h),
              const Divider(),

              Expanded(
                child: commentState.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.redAccent, size: 36.sp),
                        SizedBox(height: 8.h),
                        Text(error.toString(),
                            style: TextStyle(
                                fontSize: 13.sp, color: Colors.grey),
                            textAlign: TextAlign.center),
                        SizedBox(height: 12.h),
                        TextButton(
                          onPressed: () => ref
                              .read(commentProvider(widget.post.postId)
                                  .notifier)
                              .refreshComments(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  data: (comments) {
                    if (comments.isEmpty) {
                      return Center(
                        child: Text(
                          'No comments yet. Be the first!',
                          style: TextStyle(
                              fontSize: 13.sp, color: Colors.grey),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () => ref
                          .read(commentProvider(widget.post.postId)
                              .notifier)
                          .refreshComments(),
                      child: ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          return CommentTile(
                            comment: comments[index],
                            depth: 0,
                            onReplyTap: _setReplyTarget,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              const Divider(height: 1),

              // Replying-to indicator
              if (_replyingTo != null)
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  color: Colors.blue.withValues(alpha: 0.08),
                  child: Row(
                    children: [
                      Icon(Icons.reply, size: 14.sp, color: Colors.blue),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          'Replying to ${_replyingTo!.userName}',
                          style: TextStyle(
                              fontSize: 12.sp, color: Colors.blue),
                        ),
                      ),
                      GestureDetector(
                        onTap: _cancelReply,
                        child: Icon(Icons.close,
                            size: 16.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

              // Comment input bar
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
                  left: 12.w,
                  right: 12.w,
                  top: 8.h,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      child: const Icon(Icons.person_outline),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        focusNode: _focusNode,
                        style: TextStyle(fontSize: 14.sp),
                        decoration: InputDecoration(
                          hintText: _replyingTo != null
                              ? 'Write a reply...'
                              : 'Write a comment...',
                          hintStyle:
                              TextStyle(fontSize: 14.sp, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.r),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).brightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.grey[200],
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: _submitComment,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
