import 'dart:convert';
import 'package:cbfapp/models/announcement_model.dart';
import 'package:cbfapp/util/baseUrl.dart';
import 'package:http/http.dart' as http;

class AnnouncementService {

  Future<AnnouncementResponse> fetchAnnouncements() async {
    final url = Uri.parse('$baseUrl/announcements/get');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return AnnouncementResponse.fromJson(jsonData);
      } else {
        throw Exception("Failed to load announcements: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching announcements: $e");
    }
  }
}
