import 'package:alumni_network/pages/create_post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  void _openCreatePostScreen() {
     Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePostPage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: Padding(
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
