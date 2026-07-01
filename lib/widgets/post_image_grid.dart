import 'package:alumni_network/core/network/api_client.dart';
import 'package:alumni_network/pages/image_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostImageGrid extends StatelessWidget {
  final List<String> images;

  const PostImageGrid({super.key, required this.images});

  void _openImageViewer(BuildContext context, int initialIndex) {
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

  @override
  Widget build(BuildContext context) {
    int count = images.length;
    if (count == 0) return const SizedBox.shrink();

    if (count == 1) {
      return _gridImageItem(context, 0, height: 220.h);
    } else if (count == 2) {
      return SizedBox(
        height: 200.h,
        child: Row(
          children: [
            Expanded(child: _gridImageItem(context, 0)),
            SizedBox(width: 4.w),
            Expanded(child: _gridImageItem(context, 1)),
          ],
        ),
      );
    } else if (count == 3) {
      return SizedBox(
        height: 220.h,
        child: Row(
          children: [
            Expanded(child: _gridImageItem(context, 0)),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _gridImageItem(context, 1)),
                  SizedBox(height: 4.h),
                  Expanded(child: _gridImageItem(context, 2)),
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
            Expanded(child: _gridImageItem(context, 0)),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: _gridImageItem(context, 1)),
                  SizedBox(height: 4.h),
                  Expanded(child: _gridImageItem(context, 2)),
                  SizedBox(height: 4.h),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(child: _gridImageItem(context, 3)),
                        if (count > 4)
                          GestureDetector(
                            onTap: () => _openImageViewer(context, 3),
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.55),
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

  Widget _gridImageItem(BuildContext context, int index, {double? height}) {
    final String baseUrl = "http://${ApiClient.ipAddress}";
    final String imageUrl = images[index];
    final String fullImageUrl = imageUrl.startsWith('http') ? imageUrl : "$baseUrl$imageUrl";
    return GestureDetector(
      onTap: () => _openImageViewer(context, index),
      child: Container(
        height: height,
        width: double.infinity,
        color: Colors.grey.shade100,
        child: Image.network(
          fullImageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(Icons.broken_image, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}