import '../../../app/app.dart';

class TypographyModel {
  final String text;
  final FontType? fontType;
  final Color? color;
  final FontStyle? fontStyle;

  const TypographyModel({
    required this.text,
    this.fontType,
    this.color,
    this.fontStyle,
  });
}