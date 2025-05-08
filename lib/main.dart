import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:docveda_app/app.dart';
import 'package:docveda_app/common/widgets/no_internet_screen/no_internet_screen.dart';
import 'package:docveda_app/common/widgets/toggle/toggleController.dart';
import 'package:flutter/material.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const ConnectionCheckApp());
}

class ConnectionCheckApp extends StatefulWidget {
  const ConnectionCheckApp({super.key});

  @override
  State<ConnectionCheckApp> createState() => _ConnectionCheckAppState();
}

class _ConnectionCheckAppState extends State<ConnectionCheckApp> {
  bool hasInternet = true;
  bool isInitializing = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivityAndInitialize();
  }

  Future<void> _checkConnectivityAndInitialize() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        hasInternet = false;
        isInitializing = false;
      });
      return;
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      Get.put(ToggleController());

      setState(() {
        hasInternet = true;
        isInitializing = false;
      });
    } catch (e) {
      print("Firebase Init Failed: $e");
      setState(() {
        hasInternet = false;
        isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isInitializing) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (!hasInternet) {
      return const MaterialApp(
        home: NoInternetScreen(),
      );
    }

    return const App();
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background FCM: ${message.notification?.title}");
}
