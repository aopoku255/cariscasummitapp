import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/MainText.dart';
import '../../models/Gallery.dart';
import '../../services/Galleryservice.dart';
import '../../util/baseUrl.dart';
import '../Fullscreenview.dart';

class DashboardResources extends StatefulWidget {
  const DashboardResources({super.key});

  @override
  State<DashboardResources> createState() => _DashboardResourcesState();
}

class _DashboardResourcesState extends State<DashboardResources> {
  late Future<GalleryImageResponse> _galleryFuture;
  final ImagePicker _picker = ImagePicker();
  final List<GalleryImage> _localImages = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _galleryFuture = GalleryService.fetchGalleryImages();
    _loadLocalImages();
  }

  Future<void> _loadLocalImages() async {
    final prefs = await SharedPreferences.getInstance();
    final localItems = prefs.getStringList('gallery_local_images')?.whereType<String>().toList() ?? [];

    final loadedImages = <GalleryImage>[];
    for (final item in localItems) {
      try {
        final map = jsonDecode(item) as Map<String, dynamic>;
        final createdAtString = map['createdAt']?.toString() ?? '';
        loadedImages.add(
          GalleryImage.local(
            id: map['id'] is int ? map['id'] as int : int.tryParse(map['id']?.toString() ?? '') ?? DateTime.now().millisecondsSinceEpoch,
            filePath: map['imageUrl']?.toString() ?? '',
            uploadedBy: map['uploadedBy']?.toString(),
            createdAt: DateTime.tryParse(createdAtString) ?? DateTime.now(),
          ),
        );
      } catch (_) {
        continue;
      }
    }

    setState(() {
      _localImages
        ..clear()
        ..addAll(loadedImages);
    });
  }

  Future<void> _saveLocalImages() async {
    final prefs = await SharedPreferences.getInstance();
    final entries = _localImages.map((image) => jsonEncode(image.toLocalJson())).toList();
    await prefs.setStringList('gallery_local_images', entries);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1600,
    );

    if (pickedFile == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final extension = pickedFile.path.contains('.') ? pickedFile.path.substring(pickedFile.path.lastIndexOf('.')) : '.jpg';
      final fileName = 'gallery_${DateTime.now().millisecondsSinceEpoch}$extension';
      final savedFile = await File(pickedFile.path).copy('${appDir.path}/$fileName');

      final uploadedImage = GalleryImage.local(
        id: DateTime.now().millisecondsSinceEpoch,
        filePath: savedFile.path,
        uploadedBy: 'You',
        createdAt: DateTime.now(),
      );

      setState(() {
        _localImages.insert(0, uploadedImage);
      });

      await _saveLocalImages();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to save image: $error')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  String _formatImageUrl(GalleryImage galleryImage) {
    final url = galleryImage.imageUrl.trim();
    if (galleryImage.isLocal || url.isEmpty) {
      return url;
    }

    if (url.startsWith('http')) {
      return url;
    }

    final origin = Uri.parse(baseUrl).origin;
    if (url.startsWith('/')) {
      return '$origin$url';
    }
    return '$origin/$url';
  }

  void _openGalleryViewer(List<GalleryImage> images, int startIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenGalleryViewer(
          images: images,
          initialIndex: startIndex,
        ),
      ),
    );
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final fileDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(fileDate).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('dd MMM yyyy').format(date);
  }

  Map<String, List<GalleryImage>> _groupImagesByDate(List<GalleryImage> images) {
    final Map<String, List<GalleryImage>> grouped = {};

    for (var image in images) {
      final label = _getDateLabel(image.createdAt);
      grouped.putIfAbsent(label, () => []).add(image);
    }

    return grouped;
  }

  Widget _buildGalleryList(List<GalleryImage> images) {
    if (images.isEmpty) {
      return const Center(child: Text('No images available.'));
    }

    final grouped = _groupImagesByDate(images);

    return ListView(
      padding: const EdgeInsets.all(10),
      children: grouped.entries.map((entry) {
        final entryImages = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            MainText(
              text: entry.key,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: entryImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final image = entryImages[index];
                final imageUrl = _formatImageUrl(image);
                return GestureDetector(
                  onTap: () => _openGalleryViewer(entryImages, index),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: image.isLocal && imageUrl.isNotEmpty
                              ? Image.file(
                                  File(imageUrl),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image)),
                                )
                              : imageUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey.shade200,
                                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                      ),
                                      errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image)),
                                    )
                                  : const Center(child: Icon(Icons.broken_image)),
                        ),
                        Positioned(
                          left: 8,
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              image.uploadedBy ?? 'Anonymous',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Gallery'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                _galleryFuture = GalleryService.fetchGalleryImages();
              });
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isUploading ? null : _pickImage,
        icon: _isUploading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.file_upload_rounded),
        label: const Text('Upload'),
      ),
      body: FutureBuilder<GalleryImageResponse>(
        future: _galleryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            if (_localImages.isNotEmpty) {
              return _buildGalleryList(_localImages);
            }
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            if (_localImages.isNotEmpty) {
              return _buildGalleryList(_localImages);
            }
            return Center(child: Text('Error loading gallery: ${snapshot.error}'));
          }

          final remoteImages = snapshot.data?.data ?? [];
          final allImages = [..._localImages, ...remoteImages];
          allImages.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (allImages.isEmpty) {
            return const Center(child: Text('No images available.'));
          }

          return _buildGalleryList(allImages);
        },
      ),
    );
  }
}
