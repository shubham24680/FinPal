import 'package:finpal/app/app.dart';

final analysisPeriodProvider = StateProvider<AnalysisPeriod>(
  (ref) => AnalysisPeriod.thisMonth,
);
final hideBalanceProvider = StateProvider<bool>((ref) => false);

