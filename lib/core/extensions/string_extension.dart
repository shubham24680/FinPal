import 'package:finpal/app/app.dart';

extension StringX on String {
  DateTime parseDate({DateFormatType type = DateFormatType.date}) {
    return (DateTimeX.formatters[type] ?? DateTimeX.formatters[DateFormatType.date]!).parse(this);
  }
}