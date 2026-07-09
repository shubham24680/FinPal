import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConstants {
  static final sidePadding = 16.r;
  static final bottomPadding = 40.r;
  static final appNavPadding = 60.r;
  static final mobileBreakpoint = 600.w;
  static final tabletBreakpoint = 1100.w;
}

enum CurrencyContants {
  rupee('INR', '\u20B9', 'en_IN'),
  dollar('USD', '\$', 'en_US');

  const CurrencyContants(this.currency, this.symbol, this.locale);
  final String currency, symbol, locale;
}