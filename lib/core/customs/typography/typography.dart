import 'package:finpal/app/app.dart';

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
    this.fontStyle,
    this.decoration,
    this.letterSpacing,
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
  final FontStyle? fontStyle;
  final TextDecoration? decoration;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    final typo = Text(
      text ?? "",
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: getTextStyle(context),
    );

    return typo;
  }

  TextStyle getTextStyle(BuildContext context) => TextStyle(
    fontFamily: family,
    color: color ?? Theme.of(context).colorScheme.onInverseSurface,
    fontStyle: fontStyle ?? FontStyle.normal,
    decoration: decoration ?? TextDecoration.none,
    fontSize: size ?? fontType.fontSize,
    fontWeight: weight ?? fontType.fontWeight,
    height: height ?? fontType.height,
    letterSpacing: letterSpacing ?? fontType.letterSpacing,
  );
}
