import 'package:intl/intl.dart';
import '../constants/constants.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static const defaultDecimal = 2;
  static const deafultCompact = false;

  static String format(
    double? amount, {
    CurrencyContants currency = CurrencyContants.rupee,
    int decimalDigits = defaultDecimal,
    bool compact = deafultCompact,
  }) {
    final symbol = currency.symbol;
    if (amount == null) return '${symbol}0.00';

    if (compact) {
      return CurrencyFormatter.compact(
        amount,
        currency: currency,
        decimalDigits: decimalDigits,
      );
    }

    final formatter = NumberFormat.currency(
      locale: currency.locale,
      symbol: currency.symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }
  static double parse(
    String amount, {
    CurrencyContants currency = CurrencyContants.rupee,
    int decimalDigits = defaultDecimal,
    bool compact = deafultCompact,
  }) {
    final formatter = NumberFormat.currency(
      locale: currency.locale,
      symbol: currency.symbol,
      decimalDigits: decimalDigits,
    );
    final value = formatter.parse(amount);
    return value as double;
  }

  static String compact(
    double amount, {
    CurrencyContants currency = CurrencyContants.rupee,
    int decimalDigits = defaultDecimal,
    bool compact = deafultCompact,
  }) {
    final formatter = NumberFormat.compactCurrency(
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
    final grouped = NumberFormat.currency(
      locale: currency.locale,
      symbol: currency.symbol,
      decimalDigits: 0,
    ).format(number);

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
}
