import 'package:finpal/core/constants/app_constants.dart';
import 'package:finpal/core/customs/text_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

TextEditingValue _value(String text, [int? cursor]) => TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: cursor ?? text.length),
    );

void main() {
  group('NameInputFormatter', () {
    final formatter = NameInputFormatter();

    test('allows letters and single spaces', () {
      final result = formatter.formatEditUpdate(
        _value(''),
        _value('John Doe'),
      );
      expect(result.text, 'John Doe');
    });

    test('strips digits and symbols (failure path)', () {
      final result = formatter.formatEditUpdate(
        _value(''),
        _value('John123!'),
      );
      expect(result.text, 'John');
    });

    test('collapses leading and repeated spaces', () {
      final result = formatter.formatEditUpdate(
        _value(''),
        _value('  Jane   Doe'),
      );
      expect(result.text, 'Jane Doe');
    });

    test('keeps empty input', () {
      final result = formatter.formatEditUpdate(_value('a'), _value(''));
      expect(result.text, isEmpty);
    });
  });

  group('AmountInputFormatter', () {
    final formatter = AmountInputFormatter(
      currency: CurrencyContants.rupee,
      decimalDigits: 2,
    );

    test('formats typed digits with currency grouping', () {
      final result = formatter.formatEditUpdate(_value(''), _value('1234'));
      expect(result.text, contains('1,234'));
      expect(result.text, startsWith('₹'));
    });

    test('rejects more than max decimal digits (hold previous)', () {
      final old = formatter.formatEditUpdate(_value(''), _value('12.34'));
      final held = formatter.formatEditUpdate(old, _value('${old.text}5'));
      expect(held.text, old.text);
    });

    test('clears to empty', () {
      final result = formatter.formatEditUpdate(_value('₹12'), _value(''));
      expect(result.text, isEmpty);
    });
  });
}
