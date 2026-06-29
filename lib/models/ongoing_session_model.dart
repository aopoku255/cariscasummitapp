import 'ongoing_model.dart';

class OngoingSession {
  final String id;
  final String name;
  final String topic;
  final String starttime;
  final String endtime;
  final Session session;
  final List<Speaker> speakers;

  OngoingSession({
    required this.id,
    required this.name,
    required this.topic,
    required this.starttime,
    required this.endtime,
    required this.session,
    required this.speakers,
  });

  factory OngoingSession.fromJson(Map<String, dynamic> json) {
    return OngoingSession(
      id: json['id'],
      name: json['name'],
      topic: json['topic'],
      starttime: json['starttime'],
      endtime: json['endtime'],
      session: Session.fromJson(json['session']),
      speakers: (json['speakers'] as List<dynamic>)
          .map((e) => Speaker.fromJson(e))
          .toList(),
    );
  }
}
