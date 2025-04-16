class DateFormatter {
  /// Converts "dd/MM/yyyy" or "dd/MM/yyyy HH:mm:ss" to "9th Feb, 25"
  static String formatDate(String? inputDate) {
    if (inputDate == null || inputDate.isEmpty) return "N/A";

    try {
      DateTime parsedDate;

      // Handle dd/MM/yyyy or dd/MM/yyyy HH:mm:ss
      if (inputDate.contains('/')) {
        List<String> parts = inputDate.split(' ');
        List<String> dateParts = parts[0].split('/');

        if (dateParts.length != 3) return inputDate;

        int day = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int year = int.parse(dateParts[2]);

        parsedDate = DateTime(year, month, day);
      }
      // Handle yyyy-MM-dd or yyyy-MM-ddTHH:mm:ss
      else if (inputDate.contains('-')) {
        parsedDate = DateTime.parse(inputDate);
      } else {
        return inputDate; // unknown format
      }

      int day = parsedDate.day;
      String suffix = _getDaySuffix(day);
      String monthName = _monthShortName(parsedDate.month);
      String shortYear = parsedDate.year.toString().substring(2);

      return '$day$suffix $monthName, $shortYear';
    } catch (e) {
      return "N/A";
    }
  }

  /// Gets the appropriate suffix for a day (st, nd, rd, th)
  static String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  /// Converts month number to short name
  static String _monthShortName(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return monthNames[month - 1];
  }
}
