import 'package:finpal/core/common/responsive_builder/responsive_breakpoints.dart';

class ResponsiveValue<T> {
  const ResponsiveValue({required this.mobile, this.tablet, this.desktop});

  final T mobile;
  final T? tablet;
  final T? desktop;

  T resolve(ScreenType screenType) => switch (screenType) {
    ScreenType.mobile => mobile,
    ScreenType.tablet => tablet ?? mobile,
    ScreenType.desktop => desktop ?? tablet ?? mobile,
  };

  T resolveWidth(double width) => resolve(ScreenType.fromWidth(width));
}
