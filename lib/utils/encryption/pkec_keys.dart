import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class PKCEKeys {
  static Map<String, String> generatePKCEKeys() {
    final codeVerifier = _generateRandomString(
      43,
    ); // Generate 43-character random string
    final codeChallenge = _generateCodeChallenge(codeVerifier);

    return {"code_verifier": codeVerifier, "code_challenge": codeChallenge};
  }

  // Generate a random string for the code verifier
  static String _generateRandomString(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  // Generate the code challenge using SHA256 and Base64URL encoding
  static String _generateCodeChallenge(String codeVerifier) {
    final bytes = utf8.encode(codeVerifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', ''); // Remove padding
  }
}
