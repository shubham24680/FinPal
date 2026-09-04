import 'package:finpal/core/constants/constants.dart';
import 'package:finpal/core/utils/currency_formatter.dart';
import 'package:finpal/features/settings/data/notifiers/settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension CurrencyFormatRef on Ref {
  CurrencyContants get selectedCurrency => read(currencyProvider);

  String formatCurrency(
    double? amount, {
    int decimalDigits = CurrencyFormatter.defaultDecimal,
    bool compact = CurrencyFormatter.deafultCompact,
  }) =>
      CurrencyFormatter.format(
        amount,
        currency: selectedCurrency,
        decimalDigits: decimalDigits,
        compact: compact,
      );

  String formatSignedCurrency(
    double amount, {
    required bool isExpense,
  }) =>
      CurrencyFormatter.signed(
        amount,
        isExpense: isExpense,
        currency: selectedCurrency,
      );

  String formatCurrencyInput(
    String raw, {
    int decimalDigits = 2,
  }) =>
      CurrencyFormatter.formatInput(
        raw,
        currency: selectedCurrency,
        decimalDigits: decimalDigits,
      );

  String formatAmountForInput(
    double amount, {
    int decimalDigits = 2,
  }) =>
      CurrencyFormatter.formatAmountForInput(
        amount,
        currency: selectedCurrency,
        decimalDigits: decimalDigits,
      );

  double parseCurrency(
    String amount, {
    int decimalDigits = CurrencyFormatter.defaultDecimal,
  }) =>
      CurrencyFormatter.parse(
        amount,
        currency: selectedCurrency,
        decimalDigits: decimalDigits,
      );
}

extension CurrencyFormatWidgetRef on WidgetRef {
  CurrencyContants get selectedCurrency => watch(currencyProvider);

  String formatCurrency(
    double? amount, {
    int decimalDigits = CurrencyFormatter.defaultDecimal,
    bool compact = CurrencyFormatter.deafultCompact,
  }) =>
      CurrencyFormatter.format(
        amount,
        currency: selectedCurrency,
        decimalDigits: decimalDigits,
        compact: compact,
      );

  String formatSignedCurrency(
    double amount, {
    required bool isExpense,
  }) =>
      CurrencyFormatter.signed(
        amount,
        isExpense: isExpense,
        currency: selectedCurrency,
      );

  String formatCurrencyInput(
    String raw, {
    int decimalDigits = 2,
  }) =>
      CurrencyFormatter.formatInput(
        raw,
        currency: selectedCurrency,
        decimalDigits: decimalDigits,
      );

  String formatAmountForInput(
    double amount, {
    int decimalDigits = 2,
  }) =>
      CurrencyFormatter.formatAmountForInput(
        amount,
        currency: selectedCurrency,
        decimalDigits: decimalDigits,
      );

  double parseCurrency(
    String amount, {
    int decimalDigits = CurrencyFormatter.defaultDecimal,
  }) =>
      CurrencyFormatter.parse(
        amount,
        currency: selectedCurrency,
        decimalDigits: decimalDigits,
      );
}
