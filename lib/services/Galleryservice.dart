import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Gallery.dart';
import '../util/baseUrl.dart'; // adjust the path if needed

class GalleryService {
  // static const String baseUrl = 'https://your-backend-url.com'; // Replace with your actual backend URL
  static const String endpoint = '/user/get-all-images'; // Adjust if your route is different

  // Fetch all gallery images
  static Future<GalleryImageResponse> fetchGalleryImages() async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        try {
          return GalleryImageResponse.fromJson(jsonData);
        } catch (error) {
          throw Exception('Invalid gallery response: $error');
        }
      } else {
        throw Exception('Failed to fetch gallery images: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching gallery images: $e');
    }
  }
}
