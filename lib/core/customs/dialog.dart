import 'dart:async';

import 'package:finpal/app/app.dart';

class CustomDialog extends StatefulWidget {
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
  final FutureOr<void> Function() onPressed;
  final String? icon;
  final Color? iconColor;
  final Color? iconBgColor;

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    required String buttonText,
    required FutureOr<void> Function() onPressed,
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
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  bool _isLoading = false;

  Future<void> _handlePressed() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await widget.onPressed();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon:
          widget.icon != null
              ? Center(
                child: CustomContainer(
                  borderRadius: BorderRadius.circular(1000.r),
                  backgroundColor: widget.iconBgColor ?? AppColors.primary50,
                  child: CustomImage(
                    imageType: ImageType.svgLocal,
                    imageUrl: widget.icon,
                    height: 40.spMin,
                    width: 40.spMin,
                    color: widget.iconColor ?? AppColors.primary500,
                  ),
                ),
              )
              : null,
      title: CustomTypography(text: widget.title, fontType: FontType.body1Bold),
      content: CustomTypography(
        text: widget.message,
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
        if (_isLoading)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 8.r),
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(100.r),
              minHeight: 4.spMin,
              color: widget.buttonColor,
              backgroundColor: widget.buttonColor.withAlpha(40),
            ),
          )
        else
          Row(
            spacing: 8.spMin,
            children: [
              Expanded(
                child: AnimatedTap(
                  onTap: () => context.pop(),
                  child: CustomTypography(
                    text: "Cancel",
                    fontType: FontType.body1Medium,
                    color: AppColors.neutral500,
                    align: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 24.spMin,
                color: context.colors.outline,
              ),
              Expanded(
                child: AnimatedTap(
                  onTap: _handlePressed,
                  child: CustomTypography(
                    text: widget.buttonText,
                    fontType: FontType.body1Medium,
                    color: widget.buttonColor,
                    align: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
