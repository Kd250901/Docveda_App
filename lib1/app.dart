import 'package:docveda_app/features/authentication/screens/login/login.dart';
import 'package:docveda_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690), // Set your base design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: DocvedaAppTheme.lightTheme,
          darkTheme: DocvedaAppTheme.darkTheme,
          home: const LoginScreen(),
        );
      },
    );
  }
}
