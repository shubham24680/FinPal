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
    this.typos,
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
  final List<TypographyModel>? typos;

  @override
  Widget build(BuildContext context) {
    final typos = this.typos;
    if (typos != null) {
      return RichText(
        textAlign: align ?? TextAlign.center,
        overflow: overflow ?? TextOverflow.clip,
        maxLines: maxLines,
        text: TextSpan(
          children:
              typos.map(
                    (e) => TextSpan(
                      text: e.text,
                      style: CustomTypography(
                        text: e.text,
                        fontType: e.fontType ?? FontType.h2Medium,
                        color: e.color,
                        fontStyle: e.fontStyle,
                      ).getTextStyle(context),
                    ),
                  )
                  .toList(),
        ),
      );
    }

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
    color: color ?? context.colors.onInverseSurface,
    fontStyle: fontStyle ?? FontStyle.normal,
    decoration: decoration ?? TextDecoration.none,
    decorationColor: color ?? context.colors.onInverseSurface,
    fontSize: size ?? fontType.fontSize,
    fontWeight: weight ?? fontType.fontWeight,
    height: height ?? fontType.height,
    letterSpacing: letterSpacing ?? fontType.letterSpacing,
  );
}
