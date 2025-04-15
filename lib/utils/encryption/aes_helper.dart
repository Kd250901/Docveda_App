import 'package:encrypt/encrypt.dart' as encrypt;

class AESHelper {
  static final _key = encrypt.Key.fromUtf8(
    'MDEyMzQ1Njc4OTAxMjM0NQ==',
  ); // 32-byte key
  static final _iv = encrypt.IV.fromUtf8('cmFuZG9tSVZzdHJp'); // 16-byte IV
  static final _encrypter = encrypt.Encrypter(
    encrypt.AES(_key, mode: encrypt.AESMode.cbc),
  );

  // Encrypt method
  static String encryptText(String text) {
    final encrypted = _encrypter.encrypt(text, iv: _iv);
    return encrypted.base64; // Return encrypted text as Base64
  }

  // Decrypt method
  static String decryptText(String encryptedText) {
    final decrypted = _encrypter.decrypt64(encryptedText, iv: _iv);
    return decrypted;
  }
}
