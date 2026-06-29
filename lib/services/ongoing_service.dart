import 'dart:convert';
import 'package:cbfapp/models/ongoing_model.dart';
import 'package:cbfapp/util/baseUrl.dart';
import 'package:cbfapp/util/constants.dart';
import 'package:http/http.dart' as http;

 // update with your correct path

class ParallelSessionsService {
  final String ongoingUrl = '$baseUrl${apiRoutes['FETCH_PARALLEL_ONGOING_SESSION']}';
  final String upcomingUrl = '$baseUrl${apiRoutes['FETCH_PARALLEL_UPCOMING_SESSION']}';
  final String parallelUrl = '$baseUrl${apiRoutes['FETCH_PARALLEL_SESSION']}';

  Future<ParallelSessionsResponse> fetchOngoingSessions() async {
    final response = await http.get(Uri.parse(ongoingUrl));
    print(response.body);
    if (response.statusCode == 200) {
      return ParallelSessionsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load ongoing sessions: ${response.statusCode}');
    }
  }

  Future<ParallelSessionsResponse> fetchUpcomingSessions() async {
    final response = await http.get(Uri.parse(upcomingUrl));
    print(response.body);
    if (response.statusCode == 200) {

      return ParallelSessionsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load upcoming sessions: ${response.statusCode}');
    }
  }

  Future<ParallelSessionsResponse> fetchParallelSessions() async {
    final response = await http.get(Uri.parse(parallelUrl));
    if (response.statusCode == 200) {

      return ParallelSessionsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load upcoming sessions: ${response.statusCode}');
    }
  }
}

