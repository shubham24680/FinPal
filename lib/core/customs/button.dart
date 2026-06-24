import 'package:finpal/app/app.dart';

enum ButtonType { primary, negative, inherit }

enum ButtonVariant { primary, secondary }

enum ButtonState { enabled, loading, disabled }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.buttonType = ButtonType.primary,
    this.buttonVariant = ButtonVariant.primary,
    this.buttonState = ButtonState.enabled,
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
            color: foregroundColor,
            height: 24.spMin,
          ),
        CustomTypography(
          text: label ?? "Submit",
          color:
              buttonVariant == ButtonVariant.secondary
                  ? backgroundColor
                  : foregroundColor,
          fontType: FontType.body1Medium,
        ),
        if (suffixIcon != null)
          CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: suffixIcon,
            color: foregroundColor,
            height: 24.spMin,
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
      showShadow: buttonVariant == ButtonVariant.primary,
      backgroundColor:
          buttonVariant == ButtonVariant.primary
              ? backgroundColor
              : Colors.transparent,
      border:
          buttonVariant == ButtonVariant.secondary
              ? Border.all(color: backgroundColor)
              : null,
      margin: margin,
      child: child,
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    if (buttonState == ButtonState.disabled) {
      return context.colors.surfaceContainerHighest.withAlpha(100);
    }

    return switch (buttonType) {
      ButtonType.primary => AppColors.primary700,
      ButtonType.negative => AppColors.error700,
      ButtonType.inherit => context.colors.surfaceContainerHighest,
    };
  }

  Color _getLabelColor(BuildContext context) {
    if (buttonState == ButtonState.disabled) {
      return AppColors.neutral500.withAlpha(100);
    }

    return switch (buttonType) {
      _ => AppColors.white,
    };
  }
}
