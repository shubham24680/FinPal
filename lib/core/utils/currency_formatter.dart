import 'package:intl/intl.dart';
import '../constants/constants.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(
    double? amount, {
    CurrencyContants currency = CurrencyContants.rupee,
    int decimalDigits = 2,
    bool compact = false,
  }) {
    final symbol = currency.symbol;
    if (amount == null) return '${symbol}0.00';

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
      locale: currency.locale,
      symbol: currency.symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  /// Returns '+₹X' for income, '−₹X' for expenses.
  static String signed(
    double amount, {
    required bool isExpense,
    CurrencyContants currency = CurrencyContants.rupee,
  }) {
    final abs = format(amount.abs(), currency: currency);
    return isExpense ? '−$abs' : '+$abs';
  }

  static String formatInput(
    String raw, {
    CurrencyContants currency = CurrencyContants.rupee,
    int decimalDigits = 2,
  }) {
    if (raw.isEmpty) return '';

    final endsWithDot = raw.endsWith('.');
    final parts = raw.split('.');
    final intPart = parts[0].isEmpty ? '0' : parts[0];
    final decPart = parts.length > 1 ? parts[1] : null;

    final number = int.tryParse(intPart) ?? 0;
    final grouped = NumberFormat.currency(locale: currency.locale, symbol: currency.symbol, decimalDigits: 0).format(number);

    if (decPart == null) {
      return endsWithDot ? '$grouped.' : grouped;
    }

    final limited =
        decPart.length > decimalDigits
            ? decPart.substring(0, decimalDigits)
            : decPart;
    return '$grouped.$limited';
  }

  static String formatAmountForInput(
    double amount, {
    CurrencyContants currency = CurrencyContants.rupee,
    int decimalDigits = 2,
  }) {
    final raw =
        amount == amount.roundToDouble()
            ? amount.toStringAsFixed(0)
            : amount.toStringAsFixed(decimalDigits);
    return formatInput(raw, currency: currency, decimalDigits: decimalDigits);
  }

  static double parse(String value) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty || cleaned == '.') return 0.0;
    return double.tryParse(cleaned) ?? 0.0;
  }
}
