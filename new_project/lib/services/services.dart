import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:new_project/api/local_api.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/locator.dart';

class HttpService {
  HttpService();

  String baseUrl = Constants.apiEndpoints;

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$endpoint'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data,
      {bool auth = false}) async {
    try {
      var headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      String? token = await localApi.getKey('token');
      var authheaders = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token ?? ''
      };

      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: auth ? authheaders : headers,
        body: jsonEncode(data),
      );

      log(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create resource');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to connect to the server');
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update resource');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }

  Future<void> delete(String endpoint) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete resource');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server');
    }
  }
}
