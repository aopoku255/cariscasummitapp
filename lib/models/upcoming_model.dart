class ParallelSessionsResponse {
  final String status;
  final String message;
  final List<SessionData> data;

  ParallelSessionsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ParallelSessionsResponse.fromJson(Map<String, dynamic> json) {
    return ParallelSessionsResponse(
      status: json['status'],
      message: json['message'],
      data: List<SessionData>.from(
        json['data'].map((item) => SessionData.fromJson(item)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class SessionData {
  final int id;
  final int sessionId;
  final String starttime;
  final String endtime;
  final String name;
  final String topic;
  final String? sessionchair;
  final String? hall;
  final String? zoomlink;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Session session;
  final List<Speaker> speakers;

  SessionData({
    required this.id,
    required this.sessionId,
    required this.starttime,
    required this.endtime,
    required this.name,
    required this.topic,
    this.sessionchair,
    this.hall,
    this.zoomlink,
    required this.createdAt,
    required this.updatedAt,
    required this.session,
    required this.speakers,
  });

  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      id: json['id'],
      sessionId: json['sessionId'],
      starttime: json['starttime'],
      endtime: json['endtime'],
      name: json['name'],
      topic: json['topic'],
      sessionchair: json['sessionchair'],
      hall: json['hall'],
      zoomlink: json['zoomlink'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      session: Session.fromJson(json['session']),
      speakers: List<Speaker>.from(
        json['Speakers'].map((s) => Speaker.fromJson(s)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'starttime': starttime,
      'endtime': endtime,
      'name': name,
      'topic': topic,
      'sessionchair': sessionchair,
      'hall': hall,
      'zoomlink': zoomlink,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'session': session.toJson(),
      'Speakers': speakers.map((s) => s.toJson()).toList(),
    };
  }
}

class Session {
  final int id;
  final String name;
  final DateTime date;

  Session({
    required this.id,
    required this.name,
    required this.date,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      name: json['name'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
    };
  }
}

class Speaker {
  final int id;
  final String prefix;
  final String fname;
  final String lname;
  final String? suffix;
  final String email;
  final String linkedin;
  final String company;
  final String bio;
  final String image;
  final String? notes;
  final String custom;
  final DateTime createdAt;
  final DateTime updatedAt;

  Speaker({
    required this.id,
    required this.prefix,
    required this.fname,
    required this.lname,
    this.suffix,
    required this.email,
    required this.linkedin,
    required this.company,
    required this.bio,
    required this.image,
    this.notes,
    required this.custom,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      id: json['id'],
      prefix: json['prefix'],
      fname: json['fname'],
      lname: json['lname'],
      suffix: json['suffix'],
      email: json['email'],
      linkedin: json['linkedin'],
      company: json['company'],
      bio: json['bio'],
      image: json['image'],
      notes: json['notes'],
      custom: json['custom'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prefix': prefix,
      'fname': fname,
      'lname': lname,
      'suffix': suffix,
      'email': email,
      'linkedin': linkedin,
      'company': company,
      'bio': bio,
      'image': image,
      'notes': notes,
      'custom': custom,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
