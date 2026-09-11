import 'package:finpal/app/app.dart';

enum ButtonState { enabled, loading, disabled }

enum ButtonType { primary, negative, inherit }

enum ButtonVariant { primary, secondary, tertiary }

enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.buttonType = ButtonType.primary,
    this.buttonVariant = ButtonVariant.primary,
    this.buttonState = ButtonState.enabled,
    this.buttonSize = ButtonSize.medium,
    this.onTap,
    this.margin,
    this.prefixIcon,
    this.suffixIcon,
    this.label,
    this.bgColor,
    this.labelColor,
    this.isFull = true,
  });

  final ButtonType buttonType;
  final ButtonVariant buttonVariant;
  final ButtonState buttonState;
  final ButtonSize buttonSize;
  final VoidCallback? onTap;
  final EdgeInsets? margin;
  final String? prefixIcon;
  final String? suffixIcon;
  final String? label;
  final Color? bgColor;
  final Color? labelColor;
  final bool isFull;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = bgColor ?? _getBackgroundColor(context);
    final foregroundColor = labelColor ?? _getLabelColor(context);

    final child = Row(
      spacing: 8.w,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: isFull ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (prefixIcon != null)
          CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: prefixIcon,
            color:
                buttonVariant == ButtonVariant.secondary
                    ? backgroundColor
                    : foregroundColor,
            height: _getIconSize(),
          ),
        CustomTypography(
          text: label ?? "Submit",
          color:
              buttonVariant == ButtonVariant.secondary
                  ? backgroundColor
                  : foregroundColor,
          fontType: _getFontType(),
        ),
        if (suffixIcon != null)
          CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: suffixIcon,
            color:
                buttonVariant == ButtonVariant.secondary
                    ? backgroundColor
                    : foregroundColor,
            height: _getIconSize(),
          ),
      ],
    );

    if (buttonState == ButtonState.loading) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          color: backgroundColor,
          strokeCap: StrokeCap.round,
        ),
      );
    }

    return CustomContainer(
      onTap: buttonState == ButtonState.enabled ? onTap : null,
      showShadow: buttonVariant != ButtonVariant.secondary,
      backgroundColor:
          buttonVariant == ButtonVariant.secondary
              ? Colors.transparent
              : backgroundColor,
      border:
          buttonVariant == ButtonVariant.secondary
              ? Border.all(color: backgroundColor)
              : null,
      margin: margin,
      child: child,
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    final isDark = context.isDarkMode;
    final isDisabled = buttonState == ButtonState.disabled;
    final darkButton = isDark && buttonVariant == ButtonVariant.tertiary;

    if (isDisabled || darkButton) {
      return isDark
          ? AppColors.darkSurface2.withAlpha(100)
          : AppColors.lightSurface2;
    }

    return switch ((buttonType, buttonVariant)) {
      (ButtonType.primary, ButtonVariant.tertiary) => AppColors.primary50,
      (ButtonType.primary, _) => AppColors.primary700,
      (ButtonType.negative, ButtonVariant.tertiary) => AppColors.error50,
      (ButtonType.negative, _) => AppColors.error700,
      (ButtonType.inherit, _) =>
        isDark ? AppColors.darkSurface2.withAlpha(100) : AppColors.neutral100,
    };
  }

  Color _getLabelColor(BuildContext context) {
    if (buttonState == ButtonState.disabled) {
      return AppColors.neutral500.withAlpha(100);
    }

    return switch ((buttonType, buttonVariant)) {
      (ButtonType.primary, ButtonVariant.tertiary) => AppColors.primary500,
      (ButtonType.negative, ButtonVariant.tertiary) => AppColors.error500,
      (ButtonType.inherit, _) => AppColors.neutral500,
      _ => AppColors.white,
    };
  }

  double _getIconSize() {
    return switch (buttonSize) {
      ButtonSize.small => 20.spMin,
      ButtonSize.medium => 24.spMin,
      ButtonSize.large => 28.spMin,
    };
  }

  FontType _getFontType() {
    return switch (buttonSize) {
      ButtonSize.small => FontType.body2Medium,
      ButtonSize.medium => FontType.body1Medium,
      ButtonSize.large => FontType.h4Semibold,
    };
  }
}
