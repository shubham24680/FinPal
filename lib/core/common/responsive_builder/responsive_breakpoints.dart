abstract final class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1100;
  static const double desktop = 1440;
  static const double maxContentWidth = 1200;
}

enum ScreenType {
  mobile,
  tablet,
  desktop;

  bool get isMobile => this == ScreenType.mobile;
  bool get isTablet => this == ScreenType.tablet;
  bool get isDesktop => this == ScreenType.desktop;

  bool get isCompact => isMobile;
  bool get isMediumOrLarger => isTablet || isDesktop;

  static ScreenType fromWidth(double width) {
    if (width >= ResponsiveBreakpoints.tablet) {
      return ScreenType.desktop;
    }
    if (width >= ResponsiveBreakpoints.mobile) {
      return ScreenType.tablet;
    }
    return ScreenType.mobile;
  }
}
