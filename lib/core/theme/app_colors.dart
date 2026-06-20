import 'package:flutter/material.dart';

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

  // ── Accent — Warm Amber ───────────────────────────────────────────────────
  static const Color accent50 = Color(0xFFFFF8EC);
  static const Color accent100 = Color(0xFFFFEDC8);
  static const Color accent200 = Color(0xFFFFD88A);
  static const Color accent300 = Color(0xFFFFC04C);
  static const Color accent400 = Color(0xFFFFAB24);
  static const Color accent500 = Color(0xFFF59000); // ← main accent
  static const Color accent600 = Color(0xFFD97706);
  static const Color accent700 = Color(0xFFB45309);
  static const Color accent800 = Color(0xFF92400E);
  static const Color accent900 = Color(0xFF78350F);

  // ── Semantic — Success ─────────────────────────────────────────────────────
  static const Color success50 = Color(0xFFE8F1EB);
  static const Color success200 = Color(0xFFA1CCAE);
  static const Color success500 = Color(0xFF428A55);
  static const Color success700 = Color(0xFF337745);

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

  static const List<Color> chartPalette = [
    Color(0xFF5C7457),
    Color(0xFFF59000),
    Color(0xFF10B981),
    Color(0xFF3B82F6),
    Color(0xFFEF4444),
    Color(0xFF8B5CF6),
    Color(0xFFF97316),
    Color(0xFFEC4899),
  ];

  static const MaterialColor primarySwatch = MaterialColor(0xFF5C7457, {
    50: Color(0xFFEEF2ED),
    100: Color(0xFFD5E2D3),
    200: Color(0xFFB4C9B1),
    300: Color(0xFF8FAD8B),
    400: Color(0xFF74936F),
    500: Color(0xFF5C7457),
    600: Color(0xFF4F6449),
    700: Color(0xFF41533C),
    800: Color(0xFF34422F),
    900: Color(0xFF223020),
  });
}
