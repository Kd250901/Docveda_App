import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class THttpHelper {
  static const String _baseUrl =
      "https://api-url.com"; // Replace with actual API base URL

  /// 🔑 Get auth token from storage
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("accessToken"); // Ensure token is stored after login
  }

  /// 🛠 Common request handler with token injection
  static Future<Map<String, dynamic>> _request(
    String method,
    String endpoint, {
    dynamic data,
  }) async {
    final token = await _getToken();
    final url = Uri.parse("$_baseUrl/$endpoint");

    final headers = {
      'Content-Type': 'application/json',
      if (token != null)
        'Authorization': 'Bearer $token', // Add token if available
    };

    http.Response response;

    try {
      switch (method) {
        case "GET":
          response = await http.get(url, headers: headers);
          break;
        case "POST":
          response = await http.post(
            url,
            headers: headers,
            body: json.encode(data),
          );
          break;
        case "PUT":
          response = await http.put(
            url,
            headers: headers,
            body: json.encode(data),
          );
          break;
        case "DELETE":
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw Exception("Invalid HTTP method");
      }

      return _handleResponse(response);
    } catch (e) {
      return {
        "error": "Network error: ${e.toString()}",
      }; // Return error instead of crashing
    }
  }

  /// 🟢 GET request
  static Future<Map<String, dynamic>> get(String endpoint) =>
      _request("GET", endpoint);

  /// 🟠 POST request
  static Future<Map<String, dynamic>> post(String endpoint, dynamic data) =>
      _request("POST", endpoint, data: data);

  /// 🔵 PUT request
  static Future<Map<String, dynamic>> put(String endpoint, dynamic data) =>
      _request("PUT", endpoint, data: data);

  /// 🔴 DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint) =>
      _request("DELETE", endpoint);

  /// 🛠 Improved response handler
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final int statusCode = response.statusCode;
    final Map<String, dynamic>? responseData =
        jsonDecode(response.body) as Map<String, dynamic>?;

    if (statusCode >= 200 && statusCode < 300) {
      return responseData ?? {};
    } else if (statusCode == 401) {
      return {
        "error": "Unauthorized. Please log in again.",
      }; // Handle token expiry
    } else {
      return {
        "error":
            responseData?["message"] ??
            "Request failed with status $statusCode",
      };
    }
  }
}
