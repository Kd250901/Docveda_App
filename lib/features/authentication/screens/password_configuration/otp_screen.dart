import 'dart:async';
import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/app_text_field/app_text_field.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/features/authentication/screens/login/login.dart';
import 'package:docveda_app/features/authentication/screens/password_configuration/new_password_screen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  String _errorMessage = "";
  final String _correctOtp = "123456";

  late Timer _timer;
  int _start = 10;
  bool _isResendVisible = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _start = 10;
    _isResendVisible = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _isResendVisible = true;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _clearErrorMessage() {
    if (_errorMessage.isNotEmpty) {
      setState(() {
        _errorMessage = "";
      });
    }
  }

  void _onKeyEvent(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
      _clearErrorMessage();
    }
  }

  Widget _buildOtpField(BuildContext context, int index) {
    return SizedBox(
      height: 68,
      width: 48,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) => _onKeyEvent(event, index),
        child: DocvedaTextFormField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          onChanged: (value) {
            if (value.length == 1 && index < 5) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            }
            _clearErrorMessage();
          },
          style: Theme.of(context).textTheme.headlineMedium,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ),
    );
  }

  void _verifyOtp() {
    String enteredOtp = _controllers.map((c) => c.text).join();

    setState(() {
      if (enteredOtp.length < 6) {
        _errorMessage = "Please enter all 6 digits.";
      } else if (enteredOtp != _correctOtp) {
        _errorMessage = "Invalid OTP. Please try again.";
      } else {
        _errorMessage = "";
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NewPasswordScreen()),
        );
      }
    });
  }

  void _resendOtp() {
    // TODO: Call your resend OTP API here

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP has been resent")),
    );

    startTimer(); // Restart timer after resend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DocvedaText(
          text: "OTP Verification",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: DocvedaColors.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  DocvedaImages.darkAppLogo,
                  height: 80, // Adjust size as needed
                  width: double.infinity,
                ),
              ),
              // const SizedBox(height: 8),
              const DocvedaText(
                text: "Enter the 6-digit OTP sent to your email",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => _buildOtpField(context, index),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (_errorMessage.isNotEmpty)
                DocvedaText(
                  text: _errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              const SizedBox(height: 20),

              // Timer or Resend Option
              _isResendVisible
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _resendOtp,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor:
                              Colors.grey, // match timer text color
                        ),
                        child: const DocvedaText(
                          text: "Resend OTP",
                          style: TextStyle(
                            fontSize: 14,
                            color: DocvedaColors.primaryColor,
                            decoration: TextDecoration.none, // remove underline
                          ),
                        ),
                      ),
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: DocvedaText(
                        text:
                            "Resend OTP in 00:${_start.toString().padLeft(2, '0')}",
                        style: const TextStyle(
                            fontSize: 14, color: DocvedaColors.primaryColor),
                      ),
                    ),

              const SizedBox(height: 20),
              PrimaryButton(
                  onPressed: _verifyOtp,
                  text: 'Verify OTP',
                  backgroundColor: DocvedaColors.primaryColor),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Goes back to the previous screen
                },
                child: const DocvedaText(
                  text: "Go Back",
                  style: TextStyle(
                    fontSize: 18,
                    color: DocvedaColors.primaryColor,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
