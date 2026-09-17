import 'package:finpal/core/constants/app_constants.dart';
import 'package:finpal/core/utils/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyFormatter.format', () {
    test('formats null as zero with currency symbol', () {
      final result = CurrencyFormatter.format(null);

      expect(result, contains('0'));
      expect(result, contains(CurrencyContants.rupee.symbol));
    });

    test('formats positive amounts for INR', () {
      final result = CurrencyFormatter.format(1234.5);

      expect(result, contains('1,234.50'));
      expect(result, startsWith('₹'));
    });

    test('formats USD amounts', () {
      final result = CurrencyFormatter.format(
        99.9,
        currency: CurrencyContants.dollar,
      );

      expect(result, contains('99.90'));
      expect(result, startsWith(r'$'));
    });
  });

  group('CurrencyFormatter.parse', () {
    test('round-trips a formatted INR amount', () {
      const amount = 2500.75;
      final formatted = CurrencyFormatter.format(amount);
      final parsed = CurrencyFormatter.parse(formatted);

      expect(parsed, amount);
    });
  });

  group('CurrencyFormatter.signed', () {
    test('prefixes income with +', () {
      expect(
        CurrencyFormatter.signed(100, isExpense: false),
        startsWith('+'),
      );
    });

    test('prefixes expense with −', () {
      expect(
        CurrencyFormatter.signed(100, isExpense: true),
        startsWith('−'),
      );
    });
  });

  group('CurrencyFormatter.formatInput', () {
    test('returns empty for empty raw input', () {
      expect(CurrencyFormatter.formatInput(''), isEmpty);
    });

    test('keeps trailing decimal while typing', () {
      expect(CurrencyFormatter.formatInput('12.'), endsWith('.'));
    });

    test('limits decimal digits', () {
      expect(
        CurrencyFormatter.formatInput('12.3456', decimalDigits: 2),
        contains('.34'),
      );
      expect(
        CurrencyFormatter.formatInput('12.3456', decimalDigits: 2),
        isNot(contains('.345')),
      );
    });
  });

  group('CurrencyFormatter.formatAmountForInput', () {
    test('drops decimals for whole numbers', () {
      final result = CurrencyFormatter.formatAmountForInput(500);
      expect(result, isNot(contains('.')));
    });

    test('keeps decimals for fractional amounts', () {
      final result = CurrencyFormatter.formatAmountForInput(500.25);
      expect(result, contains('.25'));
    });
  });

  group('CurrencyFormatter.compact', () {
    test('compacts large amounts', () {
      final result = CurrencyFormatter.compact(1500000);
      expect(result.toLowerCase(), anyOf(contains('l'), contains('m')));
    });
  });
}
