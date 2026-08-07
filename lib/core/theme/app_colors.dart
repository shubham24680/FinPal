import 'package:flutter/material.dart';

enum ColorSet {
  primary(
    AppColors.primary50,
    AppColors.primary200,
    AppColors.primary700,
    AppColors.primary500,
  ),
  neutral(
    AppColors.neutral50,
    AppColors.neutral200,
    AppColors.neutral700,
    AppColors.neutral500,
  ),
  warning(
    AppColors.warning50,
    AppColors.warning200,
    AppColors.warning700,
    AppColors.warning500,
  ),
  info(
    AppColors.info50,
    AppColors.info200,
    AppColors.info700,
    AppColors.info500,
  ),
  purple(
    AppColors.purple50,
    AppColors.purple200,
    AppColors.purple700,
    AppColors.purple500,
  ),
  error(
    AppColors.error50,
    AppColors.error200,
    AppColors.error700,
    AppColors.error500,
  );

  const ColorSet(this.light, this.extraLight, this.dark, this.normal);
  final Color light, extraLight, dark, normal;

  Color get dimDark => dark.withAlpha(100);
}

extension ColorSetExtension on String {
  ColorSet get colorSet => ColorSet.values.firstWhere(
    (e) => e.name.toLowerCase() == toLowerCase(),
    orElse: () => ColorSet.primary,
  );
}

abstract class AppColors {
  // Primary
  static const Color primary50 = Color(0xFFE8F1EB);
  static const Color primary100 = Color(0xFFC6DFCE);
  static const Color primary200 = Color(0xFFA1CCAE);
  static const Color primary300 = Color(0xFF7DB88E);
  static const Color primary400 = Color(0xFF61A875);
  static const Color primary500 = Color(0xFF428A55); // Base
  static const Color primary600 = Color(0xFF3C824E);
  static const Color primary700 = Color(0xFF337745);
  static const Color primary800 = Color(0xFF2B6D3D);
  static const Color primary900 = Color(0xFF1E5A2D);

  // ── Neutral — Warm Grey ────────────────────────────────────────────────────
  static const Color neutral50 = Color(0xFFF7F7F6);
  static const Color neutral100 = Color(0xFFEEEDEB);
  static const Color neutral200 = Color(0xFFDDDBD8);
  static const Color neutral300 = Color(0xFFC4C2BE);
  static const Color neutral400 = Color(0xFF9E9C98);
  static const Color neutral500 = Color(0xFF7A7874);
  static const Color neutral600 = Color(0xFF5E5C58);
  static const Color neutral700 = Color(0xFF46443F);
  static const Color neutral800 = Color(0xFF2E2D2A);
  static const Color neutral900 = Color(0xFF1A1917);

  // ── Semantic — Error ──────────────────────────────────────────────────────
  static const Color error50 = Color(0xFFFEF2F2);
  static const Color error200 = Color(0xFFFECACA);
  static const Color error500 = Color(0xFFEF4444);
  static const Color error700 = Color(0xFFB91C1C);

  // ── Semantic — Warning ────────────────────────────────────────────────────
  static const Color warning50 = Color(0xFFFFFBEB);
  static const Color warning200 = Color(0xFFFDE68A);
  static const Color warning500 = Color(0xFFF59E0B);
  static const Color warning700 = Color(0xFFB45309);

  // ── Semantic — Info ───────────────────────────────────────────────────────
  static const Color info50 = Color(0xFFEFF6FF);
  static const Color info200 = Color(0xFFBFDBFE);
  static const Color info500 = Color(0xFF3B82F6);
  static const Color info700 = Color(0xFF1D4ED8);

  // ── Semantic — Profile Picture ────────────────────────────────────────────
  static const Color purple50 = Color(0xFFF1EAF9);
  static const Color purple200 = Color(0xFFCBB2E8);
  static const Color purple500 = Color(0xFF8B5CF6);
  static const Color purple700 = Color(0xFF6D28D9);

  // ── Light surfaces ────────────────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF7F7F6);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurface2 = Color(0xFFF7F7F6);
  static const Color lightBorder = Color(0xFFDDDBD8);
  static const Color lightDivider = Color(0xFFEEEDEB);

  // ── Dark surfaces ─────────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF111210);
  static const Color darkSurface = Color(0xFF1C1E1B);
  static const Color darkSurface2 = Color(0xFF252820);
  static const Color darkBorder = Color(0xFF34372D);
  static const Color darkDivider = Color(0xFF2A2D25);

  // ── Fixed ─────────────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
}
