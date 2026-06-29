class SpeakersResponseModel {
  final String status;
  final String message;
  final List<SpeakerModel> data;

  SpeakersResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SpeakersResponseModel.fromJson(Map<String, dynamic> json) {
    return SpeakersResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((e) => SpeakerModel.fromJson(e))
          .toList(),
    );
  }
}

class SpeakerModel {
  final int id;
  final String prefix;
  final String fname;
  final String lname;
  final String? suffix;
  final String email;
  final String? linkedin;
  final String company;
  final String bio;
  final String? image;
  final String? notes;
  final String custom;
  final List<ParallelSessionModel> parallelSessions;

  SpeakerModel({
    required this.id,
    required this.prefix,
    required this.fname,
    required this.lname,
    this.suffix,
    required this.email,
    this.linkedin,
    required this.company,
    required this.bio,
    this.image,
    this.notes,
    required this.custom,
    required this.parallelSessions,
  });

  factory SpeakerModel.fromJson(Map<String, dynamic> json) {
    return SpeakerModel(
      id: json['id'],
      prefix: json['prefix'] ?? '',
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      suffix: json['suffix'],
      email: json['email'] ?? '',
      linkedin: json['linkedin'],
      company: json['company'] ?? '',
      bio: json['bio'] ?? '',
      image: json['image'],
      notes: json['notes'],
      custom: json['custom'] ?? '',
      parallelSessions: (json['ParallelSessions'] as List<dynamic>)
          .map((e) => ParallelSessionModel.fromJson(e))
          .toList(),
    );
  }
}

class ParallelSessionModel {
  final int id;
  final int sessionId;
  final String startTime;
  final String endTime;
  final String name;
  final String topic;
  final String? sessionChair;
  final String? hall;
  final String? zoomlink;

  ParallelSessionModel({
    required this.id,
    required this.sessionId,
    required this.startTime,
    required this.endTime,
    required this.name,
    required this.topic,
    this.sessionChair,
    this.hall,
    this.zoomlink,
  });

  factory ParallelSessionModel.fromJson(Map<String, dynamic> json) {
    return ParallelSessionModel(
      id: json['id'],
      sessionId: json['sessionId'],
      startTime: json['starttime'] ?? '',
      endTime: json['endtime'] ?? '',
      name: json['name'] ?? '',
      topic: json['topic'] ?? '',
      sessionChair: json['sessionchair'],
      hall: json['hall'],
      zoomlink: json['zoomlink'],
    );
  }
}
