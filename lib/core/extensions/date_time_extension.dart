import 'package:intl/intl.dart';

enum DateFormatType { fullDate, shortDateWithTime, monthYear }

extension DateTimeX on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final y = DateTime.now().subtract(const Duration(days: 1));
    return year == y.year && month == y.month && day == y.day;
  }

  bool isSameMonthAs(DateTime other) =>
      year == other.year && month == other.month;

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
  DateTime get startOfMonth => DateTime(year, month);
  DateTime get endOfMonth =>
      DateTime(year, month + 1).subtract(const Duration(milliseconds: 1));

  DateTime get dateOnly => DateTime(year, month, day);

  String formatDate({DateFormatType type = DateFormatType.fullDate}) {
    return switch (type) {
      DateFormatType.shortDateWithTime => DateFormat(
        "MMM d, hh:mm a",
      ).format(this),
      DateFormatType.monthYear => DateFormat("MMM yy").format(this),
      _ => DateFormat("EE, MMM d, yyyy").format(this),
    };
  }
}
