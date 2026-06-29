class GalleryImageResponse {
  final String status;
  final String message;
  final List<GalleryImage> data;

  GalleryImageResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GalleryImageResponse.fromJson(Map<String, dynamic> json) {
    return GalleryImageResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: List<GalleryImage>.from(
        (json['data'] ?? []).map((item) => GalleryImage.fromJson(item)),
      ),
    );
  }
}

class GalleryImage {
  final int id;
  final String imageUrl;
  final String? uploadedBy;
  final DateTime createdAt;
  final bool isLocal;

  GalleryImage({
    required this.id,
    required this.imageUrl,
    required this.uploadedBy,
    required this.createdAt,
    this.isLocal = false,
  });

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    final createdAtString = json['createdAt']?.toString() ?? '';
    final createdAt = DateTime.tryParse(createdAtString) ?? DateTime.now();

    return GalleryImage(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      imageUrl: json['imageUrl']?.toString() ?? '',
      uploadedBy: json['uploadedBy']?.toString(),
      createdAt: createdAt,
      isLocal: false,
    );
  }

  factory GalleryImage.local({
    required int id,
    required String filePath,
    String? uploadedBy,
    required DateTime createdAt,
  }) {
    return GalleryImage(
      id: id,
      imageUrl: filePath,
      uploadedBy: uploadedBy,
      createdAt: createdAt,
      isLocal: true,
    );
  }

  Map<String, dynamic> toLocalJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'uploadedBy': uploadedBy,
      'createdAt': createdAt.toIso8601String(),
      'isLocal': isLocal,
    };
  }
}
