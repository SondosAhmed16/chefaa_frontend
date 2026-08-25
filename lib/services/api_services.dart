import 'dart:convert';

import 'package:chefaa_frontend/services/storage_servicse.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static const String baseURL = 'https://shefaa-backend.vercel.app/api/auth';

  // Register for patients
  static Future<http.Response?> registerPatient({
    required String name,
    required String userName,
    required String email,
    required String password,
    required String phoneNumber,
    required String role,
  }) async {
    final url = Uri.parse("$baseURL/register");
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'username': userName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'role': role,
      }),
    );
  }

  //Register fo Doctors
  static Future<http.StreamedResponse?> registerDoctor({
    required String name,
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
    required String specialization,
    required String filePath,
  }) async {
    final url = Uri.parse("$baseURL/register");
    var request = http.MultipartRequest("POST", url);

    request.fields['name'] = name;
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['phoneNumber'] = phoneNumber;
    request.fields['role'] = 'doctor';
    request.fields['specialization'] = specialization;

    request.files.add(
      await http.MultipartFile.fromPath('membership', filePath),
    );

    return await request.send();
  }

  static Future<http.Response?> login({
    required String identity,
    required String password,
  }) async {
    final url = Uri.parse('$baseURL/login');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identity': identity, 'password': password}),
    );
  }

  static Future<http.Response?> getCurrentUser() async {
    final token = await StorageServicse.getAccessToken();
    final url = Uri.parse('$baseURL/me');

    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401) {
      final isRefreshed = await refreshToken();
      if (isRefreshed) {
        final newToken = await StorageServicse.getAccessToken();
        response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $newToken',
          },
        );
      }
    }
  }

  static Future<bool> refreshToken() async {
    final refreshToken = await StorageServicse.getRefreshToken();
    if (refreshToken == null) return false;

    final url = Uri.parse('$baseURL/refresh');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await StorageServicse.updateAccessToken(data['accessToken']);
        return true;
      } else {
        await StorageServicse.clearStorage();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<void> logout() async {
    final refreshToken = await StorageServicse.getRefreshToken();
    final url = Uri.parse('$baseURL/logout');

    if (refreshToken != null) {
      try {
        await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        );
      } catch (_) {}
    }

    await StorageServicse.clearStorage();
  }
}
