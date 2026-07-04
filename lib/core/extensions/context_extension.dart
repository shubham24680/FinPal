import 'package:finpal/core/common/responsive_builder/responsive_breakpoints.dart';
import 'package:finpal/core/common/responsive_builder/responsive_value.dart';
import 'package:finpal/core/customs/typography/app_text_styles.dart';
import 'package:finpal/core/customs/typography/typography.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ToastType { normal, error, success }
extension ResponsiveContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  ScreenType get screenType => ScreenType.fromWidth(screenWidth);
  bool get isMobileScreen => screenType.isMobile;
  bool get isTabletScreen => screenType.isTablet;
  bool get isDesktopScreen => screenType.isDesktop;
  T responsive<T>({required T mobile, T? tablet, T? desktop}) =>
      ResponsiveValue<T>(
        mobile: mobile,
        tablet: tablet,
        desktop: desktop,
      ).resolve(screenType);

  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
  Orientation get orientation => MediaQuery.orientationOf(this);
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;
  FocusNode get focusNode => FocusScope.of(this);

  Color get successColor => AppColors.success500;
  Color get errorColor => AppColors.error500;
  Color get warningColor => AppColors.warning500;
  Color get infoColor => AppColors.info500;

  void showSnackBar(String message, {ToastType toastType = ToastType.normal}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: CustomTypography(
          text: message,
          fontType: FontType.body1Medium,
          color: _handleToastColor(toastType),
        ),
        backgroundColor: _handleToastBackgroundColor(toastType),
      ),
    );
  }

  Color _handleToastColor(ToastType toastType) {
    return switch (toastType) {
      ToastType.normal => colors.surface,
      ToastType.error => AppColors.error500,
      ToastType.success => AppColors.success500,
    };
  }

  Color _handleToastBackgroundColor(ToastType toastType) {
    return switch (toastType) {
      ToastType.normal => colors.inverseSurface,
      ToastType.error => AppColors.error200,
      ToastType.success => AppColors.success200,
    };
  }
}
