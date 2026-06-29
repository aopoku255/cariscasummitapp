import 'dart:convert';
import 'package:cbfapp/models/register_model.dart';
import 'package:cbfapp/util/constants.dart';
import 'package:http/http.dart' as http;

import '../util/baseUrl.dart';

class RegisterService {
  final loginUrl = '$baseUrl${apiRoutes['LOGIN']}';

  Future<RegisterModel> registerUser(String email) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return RegisterModel.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'Unable to request OTP for this email');
    }
  }

}
