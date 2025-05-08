import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static Future<void> storeTokens(
    String accessToken,
    String idToken,
    String refreshToken,
  ) async {
    final storage = FlutterSecureStorage();

    // Store tokens with correct keys
    await storage.write(key: 'accessToken', value: accessToken);
    await storage.write(key: 'idToken', value: idToken);
    await storage.write(key: 'refreshToken', value: refreshToken);
  }

  // Retrieve stored access token
  static Future<String?> getAccessToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'accessToken');
  }

  static Future<void> clearTokens() async {
    final storage = FlutterSecureStorage();

    // Remove tokens from secure storage
    await storage.delete(key: 'accessToken');
    await storage.delete(key: 'idToken');
    await storage.delete(key: 'refreshToken');

    print("Tokens cleared on logout!");
  }

  static Future<void> saveLoginInfo(
      String username, String password, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();

    if (rememberMe) {
      await prefs.setString('username', username);
      await prefs.setString('password', password);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
  }

  static Future<Map<String, dynamic>> getLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('rememberMe') ?? false;

    if (rememberMe) {
      return {
        'username': prefs.getString('username') ?? '',
        'password': prefs.getString('password') ?? '',
        'rememberMe': true
      };
    }
    return {'username': '', 'password': '', 'rememberMe': false};
  }
}
