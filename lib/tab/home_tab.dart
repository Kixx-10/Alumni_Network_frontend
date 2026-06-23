import 'package:alumni_network/data/model/action/like_reques_model.dart'; // 🚀 Like Model ကို import လုပ်ပါ
import 'package:alumni_network/data/model/post/response_post_model.dart';
import 'package:alumni_network/data/provider/auth_provider.dart'; 
import 'package:alumni_network/data/provider/like_toggle_notifier.dart'; 
import 'package:alumni_network/data/provider/response_post_notifier.dart';
import 'package:alumni_network/pages/create_post_page.dart';
import 'package:alumni_network/pages/image_view_page.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  void _openCreatePostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreatePostPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(responsePostProvider);

    final userIdAsync = ref.watch(currentUserIdProvider);
    final String currentUserId = userIdAsync.value ?? '';

    return Scaffold(
      backgroundColor: Colors.grey.shade200, 
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _projectTitle(),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 23.r,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: const AssetImage(
                          "assets/images/profile.jpg",
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: _openCreatePostScreen,
                          child: _createPostbtn(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            
            Expanded(
              child: postState.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text(
                    "Error: ${error.toString()}",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                data: (posts) {
                  if (posts.isEmpty) {
                    return const Center(child: Text("No posts available"));
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      await ref.read(responsePostProvider.notifier).refreshPosts();
                    },
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        // 🚀 _buildPostCard ဆီသို့ currentUserId ကိုပါ ပါဆယ်တွဲပို့ပေးလိုက်ပါမယ်
                        return _buildPostCard(post, currentUserId);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(ResponsePostModel post, String currentUserId) {
    List<String> images = [];
    if (post.mediaUrls != null && post.mediaUrls!.isNotEmpty) {
      if (post.mediaUrls!.contains(',')) {
        images = post.mediaUrls!.split(',').map((e) => e.trim()).toList();
      } else {
        images = [post.mediaUrls!];
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Info Header
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: const AssetImage("assets/images/profile.jpg"),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.authorName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "${post.createdDate.day}/${post.createdDate.month}/${post.createdDate.year}",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),

          if (post.content != null && post.content!.isNotEmpty) ...[
            Text(
              post.content!,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15.sp,
                height: 1.3,
              ),
            ),
            SizedBox(height: 10.h),
          ],
          if (images.isNotEmpty) ...[
            _buildFacebookImageGrid(images),
            SizedBox(height: 10.h),
          ],

          // Likes, Comments, Shares Counts Bar
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
                    child: Icon(Icons.thumb_up, size: 12.r, color: Colors.white),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    "${post.likeCount}",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "${post.commentCount} comments  •  ${post.shareCount} shares",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13.sp),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          const Divider(height: 1, thickness: 0.5, color: Colors.grey),
          SizedBox(height: 5.h),

          // Like, Comment, Share Interactive Buttons 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 🚀 Modern Way Like Button Logic
              _buildInteractionButton(
                icon: post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                label: "Like",
                iconColor: post.isLiked ? Colors.blue : Colors.grey.shade700,
                textColor: post.isLiked ? Colors.blue : Colors.grey.shade700,
                onTap: () async {
                  if (currentUserId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("⚠️ Please login to like this post")),
                    );
                    return;
                  }

                 //using provider if new like change color in post
                  final bool newLikeStatus = !post.isLiked;
                  ref.read(responsePostProvider.notifier).updatePostLikeStatus(
                        post.postId,
                        isLiked: newLikeStatus,
                      );

                  // ၂။ Backend API ဆီ လှမ်းပို့မယ်
                  final likeModel = LikeRequestModel(
                    postId: post.postId,
                    userId: currentUserId,
                  );

                  final isSuccess = await ref
                      .read(likeToggleProvider.notifier)
                      .toggleLike(likeModel);

                  //if api fail go original state
                  if (!isSuccess) {
                    ref.read(responsePostProvider.notifier).updatePostLikeStatus(
                          post.postId,
                          isLiked: !newLikeStatus,
                        );
                    
                    if (context.mounted) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("❌ Connection error. Failed to update like.")),
                      );
                    }
                  }
                },
              ),
              _buildInteractionButton(
                icon: Icons.mode_comment_outlined,
                label: "Comment",
                onTap: () {},
              ),
              _buildInteractionButton(
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

  Widget _buildFacebookImageGrid(List<String> images) {
    int count = images.length;

    if (count == 1) {
      return _gridImageItem(images, 0, height: 220.h);
    } else if (count == 2) {
      return SizedBox(
        height: 200.h,
        child: Row(
          children: [
            Expanded(child: _gridImageItem(images, 0)),
            SizedBox(width: 4.w),
            Expanded(child: _gridImageItem(images, 1)),
          ],
        ),
      );
    } else if (count == 3) {
      return SizedBox(
        height: 220.h,
        child: Row(
          children: [
            Expanded(child: _gridImageItem(images, 0)),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _gridImageItem(images, 1)),
                  SizedBox(height: 4.h),
                  Expanded(child: _gridImageItem(images, 2)),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        height: 240.h,
        child: Row(
          children: [
            Expanded(child: _gridImageItem(images, 0)),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _gridImageItem(images, 1)),
                  SizedBox(height: 4.h),
                  Expanded(child: _gridImageItem(images, 2)),
                  SizedBox(height: 4.h),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(child: _gridImageItem(images, 3)),
                        if (count > 4)
                          GestureDetector(
                            onTap: () => _openImageViewer(images, 3),
                            child: Container(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.55),
                              alignment: Alignment.center,
                              child: Text(
                                "+${count - 3}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _gridImageItem(List<String> images, int index, {double? height}) {
    return GestureDetector(
      onTap: () => _openImageViewer(images, index),
      child: Container(
        height: height,
        width: double.infinity,
        color: Colors.grey.shade100,
        child: Image.network(
          images[index],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(Icons.broken_image, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  void _openImageViewer(List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewerPage(
          imageUrls: images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        child: Row(
          children: [
            Icon(icon, size: 20.r, color: iconColor ?? Colors.grey.shade700),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: textColor ?? Colors.grey.shade700,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _projectTitle() {
  return Text(
    "Alumni Network",
    style: TextStyle(
      color: const Color.fromARGB(255, 43, 8, 237),
      fontWeight: FontWeight.bold,
      fontSize: 20.sp,
    ),
  );
}

Widget _createPostbtn() {
  return Container(
    height: 40.h,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: Colors.grey.shade300, width: 1.w),
    ),
    child: Text(
      "What's on your mind?",
      style: TextStyle(
        color: Colors.grey.shade600,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
