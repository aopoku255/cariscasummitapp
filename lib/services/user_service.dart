import 'dart:convert';

import 'package:cbfapp/models/user_model.dart';
import 'package:cbfapp/util/constants.dart';

import '../models/users_model.dart';
import '../util/baseUrl.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String userDetailsUrl = '$baseUrl${apiRoutes['USER_DETAILS']}';
  final String allUsers = '$baseUrl/user/get-allusers';

  Future<UserInfoModel> fetchUserDetails(int userId) async {
    final primaryUrl = Uri.parse('$userDetailsUrl/$userId');

    try {
      final response = await http.get(primaryUrl);
      if (response.statusCode == 200) {
        return UserInfoModel.fromJson(json.decode(response.body));
      }
    } catch (_) {
      // Fall back to the live list endpoint when /user/{id} is unavailable.
    }

    final fallbackResponse = await http.get(Uri.parse(allUsers));
    if (fallbackResponse.statusCode == 200) {
      final users = UsersInfoModel.fromJson(json.decode(fallbackResponse.body));
      final matchedUser = users.data.firstWhere(
        (user) => user.id == userId,
        orElse: () => throw Exception('User not found'),
      );

      return UserInfoModel(
        status: users.status,
        message: users.message,
        data: UserData(
          id: matchedUser.id,
          prefix: matchedUser.prefix,
          attendaceType: matchedUser.attendaceType,
          firstName: matchedUser.firstName,
          lastName: matchedUser.lastName,
          email: matchedUser.email,
          organization: matchedUser.organization,
          suffix: matchedUser.suffix,
          continent: matchedUser.continent,
          mobileNumber: matchedUser.mobileNumber,
          country: matchedUser.country,
          city: matchedUser.city,
          state: matchedUser.state,
          sector: matchedUser.sector,
          position: matchedUser.position,
          gender: matchedUser.gender,
          certificate: matchedUser.certificate,
          previousEvent: matchedUser.previousEvent,
          emailOptOut: matchedUser.emailOptOut,
          photoRelease: matchedUser.photoRelease,
          category: matchedUser.category,
          paymentLink: matchedUser.paymentLink,
          createdAt: matchedUser.createdAt,
          updatedAt: matchedUser.updatedAt,
        ),
      );
    }

    throw Exception('Failed to load user details: ${fallbackResponse.statusCode}');
  }

  Future<UsersInfoModel?> fetchAllUsers() async {
    final url = Uri.parse('$baseUrl/user/get-allusers');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {

        final jsonBody = json.decode(response.body);
        return UsersInfoModel.fromJson(jsonBody);
      } else {
        print('Server error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Fetch failed: $e');
      return null;
    }
  }
}