import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/model/action/like_reques_model.dart';
import 'package:alumni_network/data/model/post/response_post_model.dart';
import 'package:alumni_network/data/provider/like_toggle_notifier.dart';
import 'package:alumni_network/data/provider/response_post_notifier.dart';
import 'package:alumni_network/pages/comment_page.dart';
import 'package:alumni_network/widgets/interaction_button.dart';
import 'package:alumni_network/widgets/post_image_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostCard extends ConsumerWidget {
  final ResponsePostModel post;
  final String currentUserId;

  const PostCard({
    super.key,
    required this.post,
    required this.currentUserId,
  });

  String _resolveAvatarUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) return '';
    if (rawUrl.startsWith('http')) return rawUrl;
    final String baseUrl = 'http://${ApiClient.ipAddress}';
    return '$baseUrl$rawUrl';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> images = [];
    if (post.mediaUrls != null && post.mediaUrls!.isNotEmpty) {
      images = post.mediaUrls!.contains(',')
          ? post.mediaUrls!.split(',').map((e) => e.trim()).toList()
          : [post.mediaUrls!];
    }

    final String resolvedUrl = _resolveAvatarUrl(post.authorAvatarUrl);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: resolvedUrl.isNotEmpty
                    ? NetworkImage(resolvedUrl)
                    : const AssetImage('assets/images/profile.jpg')
                        as ImageProvider,
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.authorName,
                    style: TextStyle(
                        fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "${post.createdDate.day}/${post.createdDate.month}/${post.createdDate.year}",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Content Text
          if (post.content != null && post.content!.isNotEmpty) ...[
            Text(
              post.content!,
              style: TextStyle(fontSize: 15.sp, height: 1.3),
            ),
            SizedBox(height: 10.h),
          ],

          // Images
          if (images.isNotEmpty) ...[
            PostImageGrid(images: images),
            SizedBox(height: 10.h),
          ],

          // Counts Indicator Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: BoxDecoration(
                      color: post.isLiked ? Colors.blue : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.thumb_up,
                        size: 12, color: Colors.white),
                  ),
                  SizedBox(width: 5.w),
                  Text("${post.likeCount}",
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13.sp)),
                ],
              ),
              Text(
                "${post.commentCount} comments  •  ${post.shareCount} shares",
                style: TextStyle(
                    color: Colors.grey.shade600, fontSize: 13.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          const Divider(height: 1, thickness: 0.5, color: Colors.grey),
          SizedBox(height: 5.h),

          // Action Buttons Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InteractionButton(
                icon: post.isLiked
                    ? Icons.thumb_up
                    : Icons.thumb_up_outlined,
                label: "Like",
                iconColor:
                    post.isLiked ? Colors.blue : Colors.grey.shade700,
                textColor:
                    post.isLiked ? Colors.blue : Colors.grey.shade700,
                onTap: () async => await _handleLikeToggle(context, ref),
              ),
              InteractionButton(
                icon: Icons.mode_comment_outlined,
                label: "Comment",
                onTap: () {
                  CommentPage.show(
                    context,
                    post,
                    currentUserId,
                    onCommentPosted: () {
                      ref
                          .read(responsePostProvider.notifier)
                          .incrementCommentCount(post.postId);
                    },
                  );
                },
              ),
              InteractionButton(
                icon: Icons.share_outlined,
                label: "Share",
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
  Future<void> _handleLikeToggle(BuildContext context, WidgetRef ref) async {
    if (currentUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("⚠️ Please login to like this post")),
      );
      return;
    }

    final bool newLikeStatus = !post.isLiked;
    ref
        .read(responsePostProvider.notifier)
        .updatePostLikeStatus(post.postId, isLiked: newLikeStatus);

    final likeModel =
        LikeRequestModel(postId: post.postId, userId: currentUserId);
    final isSuccess =
        await ref.read(likeToggleProvider.notifier).toggleLike(likeModel);

    if (!isSuccess) {
      ref
          .read(responsePostProvider.notifier)
          .updatePostLikeStatus(post.postId, isLiked: !newLikeStatus);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "❌ Connection error. Failed to update like.")),
        );
      }
    }
  }
}
