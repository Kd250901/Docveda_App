import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(String? inputDate) {
    if (inputDate == null || inputDate.isEmpty) return "N/A";

    try {
      DateTime parsedDate;

      if (inputDate.contains('/')) {
        // Handles formats like "02/05/2025"
        List<String> parts = inputDate.split(' ');
        List<String> dateParts = parts[0].split('/');

        if (dateParts.length != 3) return inputDate;

        int day = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int year = int.parse(dateParts[2]);

        parsedDate = DateTime(year, month, day);
      } else if (inputDate.contains('-')) {
        // Handles formats like "2025-05-02" and "2025-05-02T00:00:00.000Z"
        parsedDate = DateTime.parse(inputDate);
      } else {
        return inputDate;
      }

      return DateFormat('yyyy-MM-dd').format(parsedDate.toLocal());
    } catch (e) {
      return "N/A";
    }
  }

  static String formatForToggle(DateTime date, bool isMonthly) {
    return isMonthly
        ? DateFormat('MMMM yyyy').format(date)
        : DateFormat('yyyy-MM-dd').format(date);
  }
}
