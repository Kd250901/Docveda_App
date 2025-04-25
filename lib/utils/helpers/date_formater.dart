import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(String? inputDate) {
    if (inputDate == null || inputDate.isEmpty) return "N/A";

    try {
      DateTime parsedDate;

      if (inputDate.contains('/')) {
        List<String> parts = inputDate.split(' ');
        List<String> dateParts = parts[0].split('/');

        if (dateParts.length != 3) return inputDate;

        int day = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int year = int.parse(dateParts[2]);

        parsedDate = DateTime(year, month, day);
      } else if (inputDate.contains('-')) {
        parsedDate = DateTime.parse(inputDate);
      } else {
        return inputDate;
      }

      return '${parsedDate.year.toString().padLeft(4, '0')}-'
          '${parsedDate.month.toString().padLeft(2, '0')}-'
          '${parsedDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return "N/A";
    }
  }

  /// ✅ New method for toggle switch (monthly/daily)
  static String formatForToggle(DateTime date, bool isMonthly) {
    return isMonthly
        ? DateFormat('MMMM yyyy').format(date) // e.g., "April 2025"
        : DateFormat('yyyy-MM-dd').format(date); // e.g., "2025-04-22"
  }
}
