import 'package:docveda_app/app.dart';
import 'package:docveda_app/common/widgets/toggle/toggleController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:docveda_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

// void main() {
//   //debugPaintSizeEnabled = true; // Shows layout bounds

//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//   ]).then((fn) {});
//   runApp(const App());
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {});
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await dotenv.load(fileName: ".env");
  // print("${dotenv.env['BASE_URL']}");
  Get.put(ToggleController());

  runApp(const App());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // NotificationServices().showNotification(message);
  print(
      "_firebaseMessagingBackgroundHandler ${message.notification?.title.toString()}");
}
