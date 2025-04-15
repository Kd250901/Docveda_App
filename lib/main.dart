import 'package:docveda_app/app.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() {
  //debugPaintSizeEnabled = true; // Shows layout bounds

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {});
  runApp(const App());
}
