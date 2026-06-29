import 'dart:convert';

import 'package:cbfapp/models/speakers_model.dart';
import 'package:cbfapp/util/baseUrl.dart';
import '../util/constants.dart';
import 'package:http/http.dart' as http;

class SpeakerService {
  final String speakerUrl = '$baseUrl${apiRoutes['FETCH_SPEAKER']}';

  Future<SpeakersResponseModel> fetchSpeakers() async {
    final response = await http.get(Uri.parse(speakerUrl));

    if (response.statusCode == 200) {

      return SpeakersResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load speakers: ${response.statusCode}');
    }
  }
}
