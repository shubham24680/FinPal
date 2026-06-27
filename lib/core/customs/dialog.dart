import 'package:finpal/app/app.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.message,
    required this.buttonText,
    this.buttonColor = AppColors.primary500,
    required this.onPressed,
    this.icon,
    this.iconColor,
    this.iconBgColor,
  });

  final String title;
  final String message;
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onPressed;
  final String? icon;
  final Color? iconColor;
  final Color? iconBgColor;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onPressed,
    Color buttonColor = AppColors.primary500,
    String? icon,
    Color? iconColor,
    Color? iconBgColor,
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
            icon: icon,
            iconColor: iconColor,
            iconBgColor: iconBgColor,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon:
          icon != null
              ? Center(
                child: CustomContainer(
                  borderRadius: BorderRadius.circular(1000.r),
                  backgroundColor: iconBgColor ?? AppColors.primary50,
                  child: CustomImage(
                    imageType: ImageType.svgLocal,
                    imageUrl: icon,
                    height: 40.spMin,
                    width: 40.spMin,
                    color: iconColor ?? AppColors.primary500,
                  ),
                ),
              )
              : null,
      title: CustomTypography(text: title, fontType: FontType.body1Bold),
      content: CustomTypography(
        text: message,
        fontType: FontType.body2Regular,
        color: context.colors.onSurface,
        align: TextAlign.center,
      ),
      contentPadding: EdgeInsets.only(
        left: 24.r,
        right: 24.r,
        bottom: 24.r,
        top: 8.r,
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
