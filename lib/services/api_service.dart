import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import 'failures.dart';

class ApiService {
  final http.Client _client = http.Client();

  Future<T> get<T>(String endpoint, T Function(dynamic) fromJson) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return fromJson(data);
      } else {
        throw ServerFailure('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerFailure('Network error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
