import 'package:intl/intl.dart';

enum DateFormatType { date, date1, monthYear, fullDate }

extension DateTimeX on DateTime {
  static final Map<DateFormatType, DateFormat> formatters = {
    DateFormatType.monthYear: DateFormat('MMMM yyyy'),
    DateFormatType.date: DateFormat('d MMMM, yyyy'),
    DateFormatType.date1: DateFormat('MMMM d, yyyy'),
    DateFormatType.fullDate: DateFormat('EEE, MMM d, yyyy'),
  };

  String formatDate({DateFormatType type = DateFormatType.date}) =>
      (formatters[type] ?? formatters[DateFormatType.date]!).format(this);

  bool isSameDayAs(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
  bool isSameMonthAs(DateTime other) =>
      year == other.year && month == other.month;
  bool get isToday => isSameDayAs(DateTime.now());
  bool get isYesterday =>
      isSameDayAs(DateTime.now().subtract(const Duration(days: 1)));
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
  DateTime get startOfMonth  => DateTime(year, month);
  DateTime get endOfMonth =>
      DateTime(year, month + 1).subtract(const Duration(milliseconds: 1));
}