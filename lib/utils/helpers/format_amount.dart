import 'package:intl/intl.dart';

class FormatAmount {
  /// Format number like "28626.00" -> "₹28,626"
  static String formatAmount(dynamic value) {
    double amount = 0.0;

    if (value is String) {
      amount = double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      amount = value.toDouble();
    }

    final format = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return format.format(amount);
  }

  /// Clean decimal if .00 (optional helper)
  static String cleanDecimal(String value) {
    final doubleAmount = double.tryParse(value) ?? 0.0;
    if (doubleAmount == doubleAmount.toInt()) {
      return doubleAmount.toInt().toString();
    } else {
      return doubleAmount.toString();
    }
  }
}
