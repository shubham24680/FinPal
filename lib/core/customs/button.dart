import 'package:finpal/app/app.dart';

enum ButtonType { primary, negative, inherit }

enum ButtonVariant { filled }

enum ButtonState { enabled, loading, disabled }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.buttonType = ButtonType.primary,
    this.buttonVariant = ButtonVariant.filled,
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
    final foregroundColor = labelColor ?? _getLabelColor();

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
          color: foregroundColor,
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
      showShadow: buttonVariant == ButtonVariant.filled,
      backgroundColor: backgroundColor,
      margin: margin,
      child: child,
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    final bgColor = switch (buttonType) {
      ButtonType.primary => AppColors.primary700,
      ButtonType.negative => AppColors.error700,
      ButtonType.inherit => context.colors.surfaceContainerHighest,
    };

    return switch (buttonState) {
      ButtonState.disabled => context.colors.surfaceContainerHighest.withAlpha(100),
      _ => bgColor,
    };
  }

  Color _getLabelColor() {
    final labelColor = switch (buttonType) {
      ButtonType.inherit => AppColors.neutral500,
      _ => AppColors.white,
    };

    return switch (buttonState) {
      ButtonState.disabled => AppColors.neutral500.withAlpha(100),
      _ => labelColor,
    };
  }
}
