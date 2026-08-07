import 'package:finpal/app/app.dart';

enum AnalysisPeriod {
  thisWeek('This week'),
  thisMonth('This month'),
  lastMonth('Last month'),
  thisYear('This year');

  const AnalysisPeriod(this.label);
  final String label;

  DateTimeRange get range {
    final now = DateTime.now();
    switch (this) {
      case AnalysisPeriod.thisWeek:
        final start = now
            .subtract(Duration(days: now.weekday - 1))
            .startOfDay;
        final end = start.add(Duration(days: 6));
        return DateTimeRange(start: start, end: end.endOfDay);
      case AnalysisPeriod.thisMonth:
        return DateTimeRange(start: now.startOfMonth, end: now.endOfMonth);
      case AnalysisPeriod.lastMonth:
        final last = DateTime(now.year, now.month - 1);
        return DateTimeRange(start: last.startOfMonth, end: last.endOfMonth);
      case AnalysisPeriod.thisYear:
        return DateTimeRange(
          start: DateTime(now.year),
          end: DateTime(now.year, 12, 31, 23, 59, 59, 999),
        );
    }
  }

// Recheck these methods
  DateTime get anchorDate => range.start;

  DateTimeRange get previousRange {
    final r = range;
    switch (this) {
      case AnalysisPeriod.thisWeek:
        final start = r.start.subtract(const Duration(days: 7));
        final end = r.start.subtract(const Duration(milliseconds: 1));
        return DateTimeRange(start: start, end: end);
      case AnalysisPeriod.thisMonth:
        return AnalysisPeriod.lastMonth.range;
      case AnalysisPeriod.lastMonth:
        final start = DateTime(r.start.year, r.start.month - 1);
        return DateTimeRange(start: start.startOfMonth, end: start.endOfMonth);
      case AnalysisPeriod.thisYear:
        final year = r.start.year - 1;
        return DateTimeRange(
          start: DateTime(year),
          end: DateTime(year, 12, 31, 23, 59, 59, 999),
        );
    }
  }
}
