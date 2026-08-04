import 'package:finpal/app/app.dart';
import 'package:intl/intl.dart';

enum DateFormatType {
  dateTime,
  fullDate,
  shortDate,
  date,
  date1,
  shortDateMonth,
  dateMonth,
  shortMonth,
  month,
  monthYear,
  time,
  shortDay,
}

extension DateTimeX on DateTime {
  static final Map<DateFormatType, DateFormat> formatters = {
    DateFormatType.dateTime: DateFormat(
      'd MMMM, yyyy ${UnicodeConstants.dot} h:mm a',
    ),
    DateFormatType.fullDate: DateFormat('EEE, MMM d, yyyy'),
    DateFormatType.shortDate: DateFormat('d MMM, yy'),
    DateFormatType.date: DateFormat('d MMMM, yyyy'),
    DateFormatType.date1: DateFormat('MMMM d, yyyy'),
    DateFormatType.shortDateMonth: DateFormat('d MMM'),
    DateFormatType.dateMonth: DateFormat('d MMMM'),
    DateFormatType.shortMonth: DateFormat('MMM'),
    DateFormatType.month: DateFormat('MMMM'),
    DateFormatType.monthYear: DateFormat('MMMM yyyy'),
    DateFormatType.time: DateFormat('h:mm a'),
    DateFormatType.shortDay: DateFormat('EEE'),
  };

  String formatDate({DateFormatType type = DateFormatType.date}) =>
      (formatters[type] ?? formatters[DateFormatType.date]!).format(this);

  bool isSameDayAs(DateTime date) =>
      year == date.year && month == date.month && day == date.day;
  bool isSameMonthAs(DateTime date) => year == date.year && month == date.month;
  bool get isToday => isSameDayAs(DateTime.now());
  bool get isYesterday =>
      isSameDayAs(DateTime.now().subtract(const Duration(days: 1)));
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
  DateTime get startOfMonth => DateTime(year, month);
  DateTime get endOfMonth =>
      DateTime(year, month + 1).subtract(const Duration(milliseconds: 1));
  String getDateLabel({DateFormatType type = DateFormatType.date}) =>
      isToday
          ? "Today"
          : isYesterday
          ? "Yesterday"
          : formatDate(type: type);
}
