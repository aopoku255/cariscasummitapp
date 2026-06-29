import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/QrcodeResponse.dart';
import '../util/baseUrl.dart';

class QrCheckinService {

  Future<QrCheckinResponseModel> checkinUserByQr({
    required int userId,
    required String checkinType,
  }) async {
    final url = Uri.parse('$baseUrl/user/checkin');
    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode({
      "userId": userId,
      "checkinType": checkinType,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 409) {
        final json = jsonDecode(response.body);
        return QrCheckinResponseModel.fromJson(json);
      } else {
        throw Exception('Failed to check in. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return QrCheckinResponseModel(
        status: "Failed",
        message: "Something went wrong: ${e.toString()}",
      );
    }
  }
}
