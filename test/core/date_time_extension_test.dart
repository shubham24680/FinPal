import 'package:finpal/core/extensions/date_time_extension.dart';
import 'package:finpal/core/extensions/string_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateTimeX', () {
    final day = DateTime(2026, 3, 15, 14, 30);

    test('isSameDayAs matches calendar day only', () {
      expect(day.isSameDayAs(DateTime(2026, 3, 15, 23, 59)), isTrue);
      expect(day.isSameDayAs(DateTime(2026, 3, 16)), isFalse);
    });

    test('isSameMonthAs matches year and month', () {
      expect(day.isSameMonthAs(DateTime(2026, 3, 1)), isTrue);
      expect(day.isSameMonthAs(DateTime(2026, 4, 15)), isFalse);
    });

    test('startOfDay and endOfDay bound the day', () {
      expect(day.startOfDay, DateTime(2026, 3, 15));
      expect(day.endOfDay.hour, 23);
      expect(day.endOfDay.millisecond, 999);
    });

    test('startOfMonth and endOfMonth bound the month', () {
      expect(day.startOfMonth, DateTime(2026, 3));
      expect(day.endOfMonth.day, 31);
      expect(day.endOfMonth.month, 3);
    });

    test('formatDate produces non-empty labels for each type', () {
      for (final type in DateFormatType.values) {
        expect(day.formatDate(type: type), isNotEmpty, reason: '$type');
      }
    });

    test('getDateLabel uses Today / Yesterday when applicable', () {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      expect(today.getDateLabel(), 'Today');
      expect(yesterday.getDateLabel(), 'Yesterday');
      expect(DateTime(2020, 1, 1).getDateLabel(), isNot(anyOf('Today', 'Yesterday')));
    });
  });

  group('StringX.parseDate', () {
    test('round-trips dateTime format', () {
      final original = DateTime(2026, 6, 1, 9, 15);
      final text = original.formatDate(type: DateFormatType.dateTime);
      final parsed = text.parseDate(type: DateFormatType.dateTime);

      expect(parsed.year, original.year);
      expect(parsed.month, original.month);
      expect(parsed.day, original.day);
      expect(parsed.hour, original.hour);
      expect(parsed.minute, original.minute);
    });
  });
}
