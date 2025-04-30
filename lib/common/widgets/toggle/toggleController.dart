import 'package:get/get.dart';

class ToggleController extends GetxController {
  // Store the toggle state (Monthly/Daily)
  var isMonthly = false.obs;

  // Function to update the toggle state
  void toggle(bool value) {
    isMonthly.value = value;
  }
}
