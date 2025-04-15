import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
}
