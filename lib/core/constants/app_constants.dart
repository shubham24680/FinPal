import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConstants {
  static final sidePadding = 16.r;
  static final bottomPadding = 40.r;
  static final appNavPadding = 60.r;
  static final mobileBreakpoint = 600.w;
  static final tabletBreakpoint = 1100.w;
}

class UnicodeConstants {
  // Currency symbols
  static const String dollar = '\u0024';
  static const String rupee = '\u20B9';

  static const String dot = '\u2022';
  static const String pipe = '\u007C';
  static const String and = '\u0026';
  static const String colon = '\u003A';
}

enum CurrencyContants {
  rupee('INR', UnicodeConstants.rupee, 'en_IN'),
  dollar('USD', UnicodeConstants.dollar, 'en_US');

  const CurrencyContants(this.currency, this.symbol, this.locale);
  final String currency, symbol, locale;
}