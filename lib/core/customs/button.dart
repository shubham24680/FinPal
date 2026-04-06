import 'package:finpal/app/app.dart';

enum ButtonType { primary, negative }

enum ButtonState { enabled, loading, disabled }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.buttonState = ButtonState.enabled,
    this.onTap,
    this.margin,
    this.icon,
    this.label,
    this.buttonType = ButtonType.primary,
    this.bgColor,
    this.labelColor,
    this.isFull = true,
  });

  final ButtonType buttonType;
  final ButtonState buttonState;
  final VoidCallback? onTap;
  final EdgeInsets? margin;
  final String? icon;
  final String? label;
  final Color? bgColor;
  final Color? labelColor;
  final bool isFull;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (buttonType) {
      ButtonType.primary => CardColors.shade1000,
      ButtonType.negative => NegativeColors.shade100,
    };
    final backgroundShade = switch (buttonState) {
      ButtonState.disabled => backgroundColor.withAlpha(100),
      _ => backgroundColor,
    };
    final textColor = switch (buttonType) {
      ButtonType.primary => Colors.white,
      ButtonType.negative => NegativeColors.shade900,
    };
    final child = switch (buttonState) {
      ButtonState.loading => Center(
        child: CircularProgressIndicator(
          color: textColor,
          strokeCap: StrokeCap.round,
        ),
      ),
      _ => Row(
        spacing: 8.w,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: isFull ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (icon != null)
            CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: icon,
              color: labelColor ?? textColor,
            ),
          CustomTypography(
            text: label ?? "Submit",
            color: labelColor ?? textColor,
            fontType: FontType.body1Medium,
          ),
        ],
      ),
    };

    return CustomContainer(
      onTap: buttonState == ButtonState.enabled ? onTap : null,
      showShadow: true,
      backgroundColor: bgColor ?? backgroundShade,
      margin: margin,
      child: child,
    );
  }
}
