import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum FontType {
  // h1 — 32
  h1Bold(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.5,
  ),
  h1Semibold(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.25,
  ),
  h1Medium(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: 0,
  ),
  h1Regular(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 1.29,
    letterSpacing: 0,
  ),
  h1Light(
    fontSize: 32,
    fontWeight: FontWeight.w300,
    height: 1.29,
    letterSpacing: 0.15,
  ),

  // h2 — 28
  h2Bold(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.29,
    letterSpacing: -0.5,
  ),
  h2Semibold(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.29,
    letterSpacing: -0.25,
  ),
  h2Medium(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    height: 1.29,
    letterSpacing: 0,
  ),
  h2Regular(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0,
  ),
  h2Light(
    fontSize: 28,
    fontWeight: FontWeight.w300,
    height: 1.33,
    letterSpacing: 0.15,
  ),

  // h3 — 24
  h3Bold(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: -0.25,
  ),
  h3Semibold(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0,
  ),
  h3Medium(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0,
  ),
  h3Regular(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0,
  ),
  h3Light(
    fontSize: 24,
    fontWeight: FontWeight.w300,
    height: 1.33,
    letterSpacing: 0.15,
  ),

  // h4 — 20
  h4Bold(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: -0.25,
  ),
  h4Semibold(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
  ),
  h4Medium(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
  ),
  h4Regular(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
  ),
  h4Light(
    fontSize: 20,
    fontWeight: FontWeight.w300,
    height: 1.4,
    letterSpacing: 0.15,
  ),

  // body1 — 16
  body1Bold(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.1,
  ),
  body1Semibold(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.15,
  ),
  body1Medium(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.15,
  ),
  body1Regular(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
  ),
  body1Light(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    height: 1.5,
    letterSpacing: 0.5,
  ),

  // body2 — 14
  body2Bold(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.4,
    letterSpacing: 0.1,
  ),
  body2Semibold(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.1,
  ),
  body2Medium(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.25,
  ),
  body2Regular(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
  ),
  body2Light(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    height: 1.43,
    letterSpacing: 0.25,
  ),

  // label1 — 12
  label1Bold(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: 0.4,
  ),
  label1SemiBold(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.5,
  ),
  label1Medium(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.5,
  ),
  label1Regular(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
  ),
  label1Light(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    height: 1.33,
    letterSpacing: 0.4,
  ),

  // label2 — 10
  label2Bold(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: 0.5,
  ),
  label2SemiBold(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.5,
  ),
  label2Medium(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.5,
  ),
  label2Regular(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.3,
    letterSpacing: 0.5,
  ),
  label2Light(
    fontSize: 10,
    fontWeight: FontWeight.w300,
    height: 1.3,
    letterSpacing: 0.5,
  );

  const FontType({
    required double fontSize,
    required this.fontWeight,
    required this.height,
    required this.letterSpacing,
  }) : _fontSize = fontSize;

  final double _fontSize;
  final FontWeight fontWeight;
  final double height;
  final double letterSpacing;

  /// Responsive font size scaled via ScreenUtil `.spMin`.
  double get fontSize => _fontSize.spMin;
}
