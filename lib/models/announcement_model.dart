class AnnouncementResponse {
  final String status;
  final String message;
  final List<Announcement> data;

  AnnouncementResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementResponse(
      status: json['status'],
      message: json['message'],
      data: List<Announcement>.from(
        json['data'].map((item) => Announcement.fromJson(item)),
      ),
    );
  }
}

class Announcement {
  final int id;
  final String name;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Announcement({
    required this.id,
    required this.name,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      name: json['name'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
