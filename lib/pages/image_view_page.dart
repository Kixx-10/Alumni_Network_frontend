import 'package:alumni_network/core/network/api_client.dart';
import 'package:flutter/material.dart';

class ImageViewerPage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageViewerPage({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    final String baseUrl = "http://${ApiClient.ipAddress}";
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${_currentIndex + 1} / ${widget.imageUrls.length}",
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final String imageUrl = widget.imageUrls[index];
          final String fullImageUrl = imageUrl.startsWith('http') ? imageUrl : "$baseUrl$imageUrl";
          return InteractiveViewer(
            clipBehavior: Clip.none,
            maxScale: 4.0,
            child: Center(
              child: Image.network(
                fullImageUrl, 
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 210, 164, 164)));
                },
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                 //color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}