import 'dart:convert';

import 'package:cbfapp/models/login_model.dart';
import 'package:cbfapp/util/constants.dart';
import 'package:http/http.dart' as http;

import '../util/baseUrl.dart';

class OtpService {
  final verifyOtpUrl = '$baseUrl${apiRoutes['VERIFY_OTP']}';

  Future<LoginModel> verifyOtp(
      {required String email, required String otp}) async {
    final response = await http.post(
      Uri.parse(verifyOtpUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'otp': otp}),
    );

    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      return LoginModel.fromJson(data);
    }

    throw Exception(
        data['message'] ?? 'Unable to verify OTP. Please try again.');
  }
}
