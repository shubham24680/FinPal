import 'package:finpal/app/app.dart';

enum FontType {
  h1Bold,
  h1Semibold,
  h2Semibold,
  h2Medium,
  body1Semibold,
  body1Medium,
  body1Regular,
  body2Semibold,
  body2Medium,
  body2Regular,
  body2Light,
  label1SemiBold,
  label1Regular,
  label1Light,
  label2Regular,
  label2Light,
}

class CustomTypography extends StatelessWidget {
  const CustomTypography({
    super.key,
    this.text,
    this.align,
    this.maxLines,
    this.overflow,
    this.fontType = FontType.body1Regular,
    this.family = AppFonts.poppins,
    this.color,
    this.size,
    this.weight,
    this.height,
  });

  final String? text;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontType fontType;
  final String family;
  final Color? color;
  final double? size;
  final FontWeight? weight;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final typo = Text(
      text ?? "",
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: getTextStyle(),
    );

    return typo;
  }

  TextStyle getTextStyle() => switch (fontType) {
    FontType.h1Bold => _getTextStyle(
      widgetSize: 32.w,
      widgetWeight: FontWeight.w900,
      widgetHeight: 1.2,
    ),
    FontType.h1Semibold => _getTextStyle(
      widgetSize: 32.w,
      widgetWeight: FontWeight.w600,
      widgetHeight: 1.2,
    ),
    FontType.h2Semibold => _getTextStyle(
      widgetSize: 28.w,
      widgetWeight: FontWeight.w600,
      widgetHeight: 1.2,
    ),
    FontType.h2Medium => _getTextStyle(
      widgetSize: 28.w,
      widgetWeight: FontWeight.w500,
      widgetHeight: 1.2,
    ),
    FontType.body1Semibold => _getTextStyle(
      widgetSize: 16.w,
      widgetWeight: FontWeight.w600,
      widgetHeight: 1.2,
    ),
    FontType.body1Medium => _getTextStyle(
      widgetSize: 16.w,
      widgetWeight: FontWeight.w500,
      widgetHeight: 1.2,
    ),
    FontType.body1Regular => _getTextStyle(
      widgetSize: 16.w,
      widgetWeight: FontWeight.w400,
      widgetHeight: 1.2,
    ),
    FontType.body2Semibold => _getTextStyle(
      widgetSize: 13.w,
      widgetWeight: FontWeight.w600,
      widgetHeight: 1.2,
    ),
    FontType.body2Medium => _getTextStyle(
      widgetSize: 13.w,
      widgetWeight: FontWeight.w500,
      widgetHeight: 1.2,
    ),
    FontType.body2Regular => _getTextStyle(
      widgetSize: 13.w,
      widgetWeight: FontWeight.w400,
      widgetHeight: 1.2,
    ),
    FontType.body2Light => _getTextStyle(
      widgetSize: 13.w,
      widgetWeight: FontWeight.w300,
      widgetHeight: 1.2,
    ),
    FontType.label1SemiBold => _getTextStyle(
      widgetSize: 10.w,
      widgetWeight: FontWeight.w600,
      widgetHeight: 1.2,
    ),
    FontType.label1Regular => _getTextStyle(
      widgetSize: 10.w,
      widgetWeight: FontWeight.w400,
      widgetHeight: 1.2,
    ),
    FontType.label1Light => _getTextStyle(
      widgetSize: 10.w,
      widgetWeight: FontWeight.w300,
      widgetHeight: 1.2,
    ),
    FontType.label2Regular => _getTextStyle(
      widgetSize: 8.w,
      widgetWeight: FontWeight.w400,
      widgetHeight: 1.2,
    ),
    FontType.label2Light => _getTextStyle(
      widgetSize: 8.w,
      widgetWeight: FontWeight.w300,
      widgetHeight: 1.2,
    ),
  };

  TextStyle _getTextStyle({
    required FontWeight widgetWeight,
    required double widgetSize,
    required double widgetHeight,
  }) => TextStyle(
    fontFamily: family,
    color: color ?? TextColors.shade900,
    fontSize: size ?? widgetSize,
    fontWeight: weight ?? widgetWeight,
    height: height ?? widgetHeight,
  );
}
