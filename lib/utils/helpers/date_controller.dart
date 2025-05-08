// lib/common/controllers/date_controller.dart
import 'package:get/get.dart';

class DateController extends GetxController {
  // Holds the selected date (default is today)
  var selectedDate = DateTime.now().obs;

  // Update the selected date
  void updateDate(DateTime newDate) {
    selectedDate.value = newDate;
  }

  // Move to previous date/month
  void goToPrevious({required bool isMonthly}) {
    if (isMonthly) {
      selectedDate.value = DateTime(
        selectedDate.value.year,
        selectedDate.value.month - 1,
        selectedDate.value.day,
      );
    } else {
      selectedDate.value = selectedDate.value.subtract(const Duration(days: 1));
    }
  }

  // Move to next date/month
  void goToNext({required bool isMonthly}) {
    if (isMonthly) {
      selectedDate.value = DateTime(
        selectedDate.value.year,
        selectedDate.value.month + 1,
        selectedDate.value.day,
      );
    } else {
      selectedDate.value = selectedDate.value.add(const Duration(days: 1));
    }
  }
}
