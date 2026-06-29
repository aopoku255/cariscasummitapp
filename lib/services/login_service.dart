import 'dart:convert';
import 'package:cbfapp/models/login_model.dart';
import 'package:cbfapp/util/constants.dart';
import 'package:http/http.dart' as http;

import '../util/baseUrl.dart';


class LoginService {
  final loginUrl = '$baseUrl${apiRoutes['LOGIN']}';

  Future<LoginModel> loginUser({required String email, required String password}) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );



    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return LoginModel.fromJson(data);
    } else {
      throw Exception('Invalid email or password');
    }
  }
}

