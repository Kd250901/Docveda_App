import 'dart:async';
import 'package:docveda_app/common/widgets/app_text/app_text.dart';
import 'package:docveda_app/common/widgets/app_text_field/app_text_field.dart';
import 'package:docveda_app/common/widgets/primary_button/primary_button.dart';
import 'package:docveda_app/features/authentication/screens/password_configuration/new_password_screen.dart';
import 'package:docveda_app/utils/constants/colors.dart';
import 'package:docveda_app/utils/constants/image_strings.dart';
import 'package:docveda_app/utils/constants/sizes.dart';
import 'package:docveda_app/utils/constants/text_strings.dart';
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
      height: DocvedaSizes.otpFieldHeight,
      width: DocvedaSizes.otpFieldWidth,
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
        _errorMessage = DocvedaTexts.enterAllDigitsErrorMsg;
      } else if (enteredOtp != _correctOtp) {
        _errorMessage = DocvedaTexts.invalidOTPErrorMsg;
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
      const SnackBar(content: Text(DocvedaTexts.OTPReset)),
    );

    startTimer(); // Restart timer after resend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DocvedaText(
          text: DocvedaTexts.OTPVerification,
          style: TextStyle(color: DocvedaColors.white),
        ),
        backgroundColor: DocvedaColors.primaryColor,
        foregroundColor: DocvedaColors.white,
        iconTheme: const IconThemeData(color: DocvedaColors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(DocvedaSizes.spaceBtwItemsLg),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  DocvedaImages.darkAppLogo,
                  height: DocvedaSizes.imgHeightMd, // Adjust size as needed
                  width: double.infinity,
                ),
              ),
              // const SizedBox(height: 8),
              const DocvedaText(
                text: DocvedaTexts.enterOTPMsg,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: DocvedaSizes.fontSizeMd),
              ),
              const SizedBox(height: DocvedaSizes.spaceBtwItemsLg),
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => _buildOtpField(context, index),
                  ),
                ),
              ),
              const SizedBox(height: DocvedaSizes.spaceBtwItemsS),
              if (_errorMessage.isNotEmpty)
                DocvedaText(
                  text: _errorMessage,
                  style:
                      const TextStyle(color: DocvedaColors.error, fontSize: 14),
                ),
              const SizedBox(height: DocvedaSizes.spaceBtwItemsLg),

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
                              DocvedaColors.grey, // match timer text color
                        ),
                        child: const DocvedaText(
                          text: DocvedaTexts.resendOTP,
                          style: TextStyle(
                            fontSize: DocvedaSizes.fontSizeSm,
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
                            fontSize: DocvedaSizes.fontSizeSm,
                            color: DocvedaColors.primaryColor),
                      ),
                    ),

              const SizedBox(height: DocvedaSizes.spaceBtwItemsLg),
              PrimaryButton(
                  onPressed: _verifyOtp,
                  text: DocvedaTexts.verifyOTP,
                  backgroundColor: DocvedaColors.primaryColor),

              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Goes back to the previous screen
                },
                child: const DocvedaText(
                  text: DocvedaTexts.goBack,
                  style: TextStyle(
                      fontSize: DocvedaSizes.fontSizeLg,
                      color: DocvedaColors.primaryColor,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
