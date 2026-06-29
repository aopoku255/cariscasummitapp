import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/Gallery.dart';
import '../util/baseUrl.dart';

class FullScreenGalleryViewer extends StatefulWidget {
  final List<GalleryImage> images;
  final int initialIndex;

  const FullScreenGalleryViewer({super.key, required this.images, required this.initialIndex});

  @override
  State<FullScreenGalleryViewer> createState() => _FullScreenGalleryViewerState();
}

class _FullScreenGalleryViewerState extends State<FullScreenGalleryViewer> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatImageUrl(GalleryImage image) {
    if (image.isLocal) {
      return image.imageUrl;
    }

    final url = image.imageUrl;
    if (url.startsWith('http')) return url;

    final origin = Uri.parse(baseUrl).origin;
    if (url.startsWith('/')) return '$origin$url';
    return '$origin/$url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          final image = widget.images[index];
          final imageUrl = _formatImageUrl(image);

          return InteractiveViewer(
            child: Stack(
              children: [
                Positioned.fill(
                  child: image.isLocal
                      ? Image.file(
                          File(imageUrl),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Icon(Icons.broken_image, color: Colors.white),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.broken_image, color: Colors.white),
                          ),
                        ),
                ),
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      image.uploadedBy ?? 'Anonymous',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
