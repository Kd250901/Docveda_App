class DateFormatter {
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

      // New format: yyyy-MM-dd
      return '${parsedDate.year.toString().padLeft(4, '0')}-'
          '${parsedDate.month.toString().padLeft(2, '0')}-'
          '${parsedDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return "N/A";
    }
  }
}
