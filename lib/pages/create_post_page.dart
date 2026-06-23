// ignore_for_file: file_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:image_picker/image_picker.dart';
import 'package:alumni_network/data/provider/create_post_notifier.dart'; 

class CreatePostPage extends ConsumerStatefulWidget { 
  const CreatePostPage({super.key});
  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> { 
  final TextEditingController _postController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> _pickedImages = [];

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage(imageQuality: 80);
    if (images.isNotEmpty) {
      setState(() {
        _pickedImages.addAll(images.map((xFile) => File(xFile.path)).toList());
      });
    }
  }

 
  Future<void> _submitPostAction() async {
    final String postText = _postController.text.trim();

    if (postText.isEmpty && _pickedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Please write something or select an image first!"),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }

    final success = await ref.read(createPostProvider.notifier).submitPost(
          content: postText.isEmpty ? null : postText, 
          pickedImages: _pickedImages,
        );

    if (success) {
      if (mounted) {
        _postController.clear();
        _pickedImages.clear();
        Navigator.pop(context); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(" Post successfully uploaded!")),
        );
      }
    } else {
      if (mounted) {
        final postState = ref.read(createPostProvider);
        final errorMsg = postState.error?.toString() ?? "Failed to create post.";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(" $errorMsg"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(createPostProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack( 
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    height: 55.h,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "New Post",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: postState.isLoading ? null : () => Navigator.pop(context),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.close, size: 26.r, color: Colors.black),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: postState.isLoading ? null : _submitPostAction,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: Colors.green,
                            ),
                            icon: Icon(Icons.check, size: 25.r),
                            label: Text("Post", style: TextStyle(fontSize: 15.sp)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
                  SizedBox(height: 15.h),

                  // Profile Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 24.r,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: const AssetImage("assets/images/profile.jpg"),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "User Name",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 3.h),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Input & Images Section
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                            child: TextField(
                              controller: _postController,
                              maxLines: null,
                              enabled: !postState.isLoading, 
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(fontSize: 18.sp, color: Colors.black87),
                              decoration: InputDecoration(
                                hintText: "What's on your mind?",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 18.sp),
                              ),
                            ),
                          ),
                          if (_pickedImages.isNotEmpty)
                            SizedBox(
                              height: 180.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                itemCount: _pickedImages.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final File imageFile = _pickedImages[index];
                                  return Padding(
                                    padding: EdgeInsets.only(right: 12.w),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10.r),
                                          child: Image.file(
                                            imageFile,
                                            height: 180.h,
                                            width: 140.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          right: 6.w,
                                          top: 6.h,
                                          child: GestureDetector(
                                            onTap: postState.isLoading
                                                ? null
                                                : () {
                                                    setState(() {
                                                      _pickedImages.removeAt(index);
                                                    });
                                                  },
                                            child: CircleAvatar(
                                              radius: 13.r,
                                              // ignore: deprecated_member_use
                                              backgroundColor: Colors.black.withOpacity(0.7),
                                              child: Icon(Icons.close, size: 14.r, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
                  
                  // Gallery Button Section
                  InkWell(
                    onTap: postState.isLoading ? null : _pickImages,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
                      child: Row(
                        children: [
                          Icon(Icons.photo_library, color: Colors.green, size: 24.r),
                          SizedBox(width: 12.w),
                          Text(
                            "Choose from gallery",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          if (_pickedImages.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                "${_pickedImages.length} selected",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          SizedBox(width: 5.w),
                          Icon(Icons.arrow_forward_ios, size: 14.r, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // 🚀 Loading စခရင် Overlay ပြသခြင်း
              if (postState.isLoading)
                Container(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.25),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}