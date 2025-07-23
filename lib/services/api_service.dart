import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import 'failures.dart';

class ApiService {
  final http.Client _client = http.Client();

  Future<T> get<T>(String endpoint, T Function(dynamic) fromJson) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

      final response = await _client
          .get(
            uri,
            headers: {
              'User-Agent':
                  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw const ServerFailure(
                'Request timeout. Please check your internet connection.',
              );
            },
          );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return fromJson(data);
      } else {
        throw ServerFailure(
          'Server error: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } on SocketException {
      // No internet connection
      throw ServerFailure(
        'No internet connection. Please check your network settings.',
      );
    } on HttpException catch (e) {
      // HTTP specific error
      throw ServerFailure('HTTP error: ${e.message}');
    } on FormatException catch (e) {
      // JSON parsing error
      throw ServerFailure('Data format error: ${e.message}');
    } catch (e) {
      // Generic error
      throw ServerFailure('Unexpected error: ${e.toString()}');
    }
  }

  void dispose() {
    _client.close();
  }
}
