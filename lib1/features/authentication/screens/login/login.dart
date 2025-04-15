import 'package:docveda_app/common/styles/spacing_styles.dart';
import 'package:docveda_app/features/authentication/screens/login/widgets/login_form.dart';
import 'package:docveda_app/features/authentication/screens/login/widgets/login_header.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: DocvedaSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title and Sub-Title
              const DocvedaLoginHeader(),

              /// Form
              DocvedaLoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
