import 'package:finpal/app/app.dart';

enum ButtonType { primary, negative }

enum ButtonVariant { filled, outlined }

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
    final backgroundShade = _getBackgroundShade(buttonState);
    final child = Row(
      spacing: 8.w,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: isFull ? MainAxisSize.max : MainAxisSize.min,
      children: [
        CustomTypography(
          text: label ?? "Submit",
          color: labelColor ?? AppColors.white,
          fontType: FontType.body1Medium,
        ),
        if (suffixIcon != null)
          CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: suffixIcon,
            color: labelColor ?? AppColors.white,
          ),
      ],
    );

    if (buttonState == ButtonState.loading) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: AppColors.white,
          color: backgroundShade,
          strokeCap: StrokeCap.round,
        ),
      );
    }

    return CustomContainer(
      onTap: buttonState == ButtonState.enabled ? onTap : null,
      showShadow: true,
      backgroundColor: bgColor ?? backgroundShade,
      margin: margin,
      child: child,
    );
  }

  Color _getBackgroundColor(ButtonType buttonType) {
    return switch (buttonType) {
      ButtonType.primary => AppColors.primary700,
      ButtonType.negative => NegativeColors.shade100,
    };
  }

  Color _getBackgroundShade(ButtonState buttonState) {
    return switch (buttonState) {
      ButtonState.disabled => _getBackgroundColor(buttonType).withAlpha(100),
      _ => _getBackgroundColor(buttonType),
    };
  }
}
