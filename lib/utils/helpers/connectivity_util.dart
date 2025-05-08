import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityUtil {
  /// Checks if device has internet connection.
  static Future<bool> hasInternetConnection() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Stream to listen for internet connectivity changes.
  static Stream<bool> get onConnectionChanged async* {
    await for (var result in Connectivity().onConnectivityChanged) {
      yield result != ConnectivityResult.none;
    }
  }
}
