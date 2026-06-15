import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(
    double? amount, {
    String symbol = '₹',
    String locale = 'en_IN',
    int decimalDigits = 2,
    bool compact = false,
  }) {
    if (amount == null) return '₹0.00';

    if (compact) {
      if (amount >= 10000000) {
        return '$symbol${(amount / 10000000).toStringAsFixed(1)}Cr';
      }
      if (amount >= 100000) {
        return '$symbol${(amount / 100000).toStringAsFixed(1)}L';
      }
      if (amount >= 1000) {
        return '$symbol${(amount / 1000).toStringAsFixed(1)}k';
      }
    }

    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  /// Returns '+₹X' for income, '−₹X' for expenses.
  static String signed(
    double amount, {
    required bool isExpense,
    String symbol = '₹',
  }) {
    final abs = format(amount.abs(), symbol: symbol);
    return isExpense ? '−$abs' : '+$abs';
  }

  static double parse(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }
}
