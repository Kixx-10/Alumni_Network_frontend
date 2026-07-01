import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/data/provider/response_profile_notifier.dart';
import 'package:alumni_network/pages/create_post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreatePostBar extends ConsumerWidget {
  const CreatePostBar({super.key});
String _resolveAvatarUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) return '';
    if (rawUrl.startsWith('http')) return rawUrl;
    final String baseUrl = 'http://${ApiClient.ipAddress}';
    return '$baseUrl$rawUrl';
  }
  @override
  Widget build(BuildContext context , WidgetRef ref) {
    final profileAsync = ref.watch(responseProfileProvider);
   final String? rawUrl = profileAsync.value?.avatarUrl;
  final String resolvedUrl = (profileAsync.isLoading || rawUrl == null) 
      ? '' 
      : _resolveAvatarUrl(rawUrl);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.h),
          Row(
            children: [
              CircleAvatar(
                radius: 23.r,
               backgroundImage: resolvedUrl.isNotEmpty
      ? NetworkImage(resolvedUrl)
      : const AssetImage('assets/images/profile.jpg') as ImageProvider,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreatePostPage()),
                  ),
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.grey.shade300, width: 1.w),
                    ),
                    child: Text(
                      "What's on your mind?",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}