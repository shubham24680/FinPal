import 'package:finpal/app/app.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    this.buttonColor = AppColors.primary500,
    required this.onPressed,
  });

  final String title;
  final String message;
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onPressed;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onPressed,
    Color buttonColor = AppColors.primary500,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => CustomDialog(
            title: title,
            message: message,
            buttonText: buttonText,
            buttonColor: buttonColor,
            onPressed: onPressed,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: CustomTypography(text: title, fontType: FontType.body1Bold),
      content: CustomTypography(
        text: message,
        fontType: FontType.body2Regular,
        color: context.colors.onSurface,
      ),

      actions: [
        Row(
          spacing: 8.spMin,
          children: [
            Expanded(
              child: CustomTypography(
                text: "Cancel",
                fontType: FontType.body1Medium,
                color: AppColors.neutral500,
                align: TextAlign.center,
              ).onTap(event: () => context.pop()),
            ),
            Container(
              width: 1,
              height: 24.spMin,
              color: context.colors.outline,
            ),
            Expanded(
              child: CustomTypography(
                text: buttonText,
                fontType: FontType.body1Medium,
                color: buttonColor,
                align: TextAlign.center,
              ).onTap(event: () => onPressed()),
            ),
          ],
        ),
      ],
    );
  }
}
