
import 'package:e_hrm/contraints/endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  Future<Map<String, dynamic>> fetchDataPrivate(String endpoint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found. Please login again.');
    }

    final response = await http.get(
      Uri.parse('${Endpoints.baseURL}/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final jsonResponse = jsonDecode(decodedResponse);
      return jsonResponse;
    } else if (response.statusCode == 401) {
      await prefs.remove('token');
      throw Exception('Unauthorized. Please login again.');
    } else {
      print("API Error [${response.statusCode}]: ${response.body}");
      throw Exception('Failed to load data from $endpoint');
    }
  }

  Future<Map<String, dynamic>> postDataPrivate(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${Endpoints.baseURL}/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      prefs.remove('token');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to post data');
    }
  }

  Future<Map<String, dynamic>> updateDataPrivate(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('${Endpoints.baseURL}/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      prefs.remove('token');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to update data');
    }
  }

  Future<Map<String, dynamic>> deleteDataPrivate(String endpoint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('${Endpoints.baseURL}/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      prefs.remove('token');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to delete data');
    }
  }

  Future<Map<String, dynamic>> post(
    Map<String, dynamic> data,
    String endpoint,
  ) async {
    final response = await http.post(
      Uri.parse('${Endpoints.baseURL}/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedResponse);
    } else {
      throw Exception(
        'Failed (${response.statusCode}): ${response.body.isEmpty ? 'No body' : response.body}',
      );
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(
    String token,
    String endpoint,
  ) async {
    final response = await http.get(
      Uri.parse('${Endpoints.baseURL}/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['user'];
    } else {
      print('Get user profile failed: ${response.statusCode}');
      return null;
    }
  }

  Future<List<dynamic>> fetchListPrivate(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found. Please login again.');
    }

    final res = await http.get(
      Uri.parse('${Endpoints.baseURL}/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final decoded = utf8.decode(res.bodyBytes);
      final jsonRes = jsonDecode(decoded);

      if (jsonRes is List) return jsonRes;

      // Beberapa API mungkin membungkus daftar di dalam { data: [...] }
      if (jsonRes is Map<String, dynamic> && jsonRes['data'] is List) {
        return List<dynamic>.from(jsonRes['data']);
      }

      throw Exception('Unexpected response shape: expected List.');
    } else if (res.statusCode == 401) {
      await prefs.remove('token');
      throw Exception('Unauthorized. Please login again.');
    } else {
      throw Exception('Failed to load list from $endpoint [${res.statusCode}]');
    }
  }
}
