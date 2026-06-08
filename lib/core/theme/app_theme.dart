import 'package:finpal/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(brightness: Brightness.light);
  static ThemeData get dark => _build(brightness: Brightness.dark);

  static ThemeData _build({required Brightness brightness}) {
    final isLight = brightness == Brightness.light;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.primary500,
      onPrimary: AppColors.white,
      primaryContainer: isLight ? AppColors.primary100 : AppColors.primary800,
      onPrimaryContainer: isLight ? AppColors.primary900 : AppColors.primary100,
      secondary: AppColors.accent500,
      onSecondary: AppColors.white,
      secondaryContainer: isLight ? AppColors.accent100 : AppColors.accent800,
      onSecondaryContainer: isLight ? AppColors.accent900 : AppColors.accent100,
      tertiary: AppColors.info500,
      onTertiary: AppColors.white,
      tertiaryContainer: isLight ? AppColors.info200 : AppColors.info700,
      onTertiaryContainer: isLight ? AppColors.info700 : AppColors.info200,
      error: AppColors.error500,
      onError: AppColors.white,
      errorContainer: isLight ? AppColors.error200 : AppColors.error700,
      onErrorContainer: isLight ? AppColors.error700 : AppColors.error200,
      surface:
          isLight
              ? AppColors.lightSurface
              : AppColors
                  .darkSurface, // container color (before scaffold background)
      surfaceContainerHighest:
          isLight
              ? AppColors.lightSurface2
              : AppColors
                  .darkSurface2, // text field fill color (before container color)
      onSurface: isLight ? AppColors.neutral400 : AppColors.neutral500,
      onSurfaceVariant: isLight ? AppColors.neutral700 : AppColors.neutral300,
      outline:
          isLight
              ? AppColors.lightBorder
              : AppColors.darkBorder, // for general border color
      outlineVariant:
          isLight
              ? AppColors.lightDivider
              : AppColors.darkDivider, // for divider color
      shadow: AppColors.black,
      scrim: AppColors.black,
      inverseSurface: isLight ? AppColors.neutral800 : AppColors.neutral100,
      onInverseSurface:
          isLight ? AppColors.neutral900 : AppColors.neutral100, // text color
      inversePrimary: isLight ? AppColors.primary200 : AppColors.primary700,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isLight ? AppColors.lightBackground : AppColors.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor:
            isLight ? AppColors.lightSurface : AppColors.darkSurface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: colorScheme.shadow.withOpacity(0.08),
        systemOverlayStyle:
            isLight
                ? SystemUiOverlayStyle.dark.copyWith(
                  statusBarColor: AppColors.transparent,
                  systemNavigationBarColor: AppColors.lightSurface,
                )
                : SystemUiOverlayStyle.light.copyWith(
                  statusBarColor: AppColors.transparent,
                  systemNavigationBarColor: AppColors.darkSurface,
                ),
        // titleTextStyle: AppTextStyles.titleLarge.copyWith(
        //   color: colorScheme.onSurface,
        // ),
        centerTitle: false,
      ),

      // ── NavigationBar (bottom) ─────────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:
            isLight ? AppColors.lightSurface : AppColors.darkSurface,
        indicatorColor: AppColors.primary500.withOpacity(0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.primary500, size: 24);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant, size: 24);
        }),
        // labelTextStyle: WidgetStateProperty.resolveWith((states) {
        //   final style = AppTextStyles.tabLabel;
        //   if (states.contains(WidgetState.selected)) {
        //     return style.copyWith(color: AppColors.primary500);
        //   }
        //   return style.copyWith(color: colorScheme.onSurfaceVariant);
        // }),
        elevation: 3,
        height: 64,
      ),

      // ── NavigationRail (tablet) ────────────────────────────────────────────
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor:
            isLight ? AppColors.lightSurface : AppColors.darkSurface,
        selectedIconTheme: const IconThemeData(
          color: AppColors.primary500,
          size: 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurfaceVariant,
          size: 24,
        ),
        indicatorColor: AppColors.primary500.withOpacity(0.15),
        // selectedLabelTextStyle: AppTextStyles.labelSmall.copyWith(
        //   color: AppColors.primary500,
        // ),
        // unselectedLabelTextStyle: AppTextStyles.labelSmall.copyWith(
        //   color: colorScheme.onSurfaceVariant,
        // ),
        elevation: 1,
      ),

      // ── Card ──────────────────────────────────────────────────────────────
      cardTheme: CardTheme(
        color: isLight ? AppColors.lightSurface : AppColors.darkSurface,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isLight ? AppColors.lightBorder : AppColors.darkBorder,
            width: 0.5,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── OutlinedButton ────────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary500,
          side: const BorderSide(color: AppColors.primary500, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          // textStyle: AppTextStyles.labelLarge,
        ),
      ),

      // ── TextButton ────────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary500,
          // textStyle: AppTextStyles.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // ── FAB ───────────────────────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary500,
        foregroundColor: AppColors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        // extendedTextStyle: AppTextStyles.labelLarge,
      ),

      // ── InputDecoration ───────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.spMin,
          vertical: 14.spMin,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.error500, width: 2),
        ),
        // hintStyle: AppTextStyles.bodyMedium.copyWith(
        //   color: colorScheme.onSurfaceVariant,
        // ),
        // labelStyle: AppTextStyles.bodyMedium.copyWith(
        //   color: colorScheme.onSurfaceVariant,
        // ),
        // floatingLabelStyle: AppTextStyles.labelMedium.copyWith(
        //   color: AppColors.primary500,
        // ),
        // errorStyle: AppTextStyles.labelSmall.copyWith(
        //   color: AppColors.error500,
        // ),
      ),

      // ── Chip ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor:
            isLight ? AppColors.lightSurface2 : AppColors.darkSurface2,
        selectedColor: AppColors.primary100,
        // labelStyle: AppTextStyles.chipLabel,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99),
          side: BorderSide(
            color: isLight ? AppColors.lightBorder : AppColors.darkBorder,
            width: 0.5,
          ),
        ),
        side: BorderSide.none,
      ),

      // ── BottomSheet ───────────────────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor:
            isLight ? AppColors.lightSurface : AppColors.darkSurface,
        modalBackgroundColor:
            isLight ? AppColors.lightSurface : AppColors.darkSurface,
        surfaceTintColor: AppColors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: true,
        dragHandleColor: isLight ? AppColors.neutral300 : AppColors.neutral600,
        dragHandleSize: const Size(40, 4),
        elevation: 8,
      ),

      // ── Dialog ────────────────────────────────────────────────────────────
      dialogTheme: DialogTheme(
        backgroundColor:
            isLight ? AppColors.lightSurface : AppColors.darkSurface,
        surfaceTintColor: AppColors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        // titleTextStyle: AppTextStyles.titleLarge.copyWith(
        //   color: colorScheme.onSurface,
        // ),
        // contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        //   color: colorScheme.onSurfaceVariant,
        // ),
      ),

      // ── SnackBar ──────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isLight ? AppColors.neutral800 : AppColors.neutral100,
        // contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        //   color: isLight ? AppColors.white : AppColors.neutral900,
        // ),
        actionTextColor: AppColors.primary300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: isLight ? AppColors.lightDivider : AppColors.darkDivider,
        thickness: 0.5,
        space: 0,
      ),

      // ── Switch ────────────────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.white;
          return isLight ? AppColors.neutral400 : AppColors.neutral600;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected))
            return AppColors.primary500;
          return isLight ? AppColors.neutral200 : AppColors.neutral700;
        }),
      ),

      // ── ListTile ──────────────────────────────────────────────────────────
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        // titleTextStyle: AppTextStyles.bodyMedium.copyWith(
        //   color: colorScheme.onSurface,
        // ),
        // subtitleTextStyle: AppTextStyles.bodySmall.copyWith(
        //   color: colorScheme.onSurfaceVariant,
        // ),
        iconColor: colorScheme.onSurfaceVariant,
        minLeadingWidth: 24,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // ── ProgressIndicator ────────────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary500,
        linearTrackColor: AppColors.primary100,
        circularTrackColor: AppColors.primary100,
        linearMinHeight: 6,
      ),

      // ── Slider ───────────────────────────────────────────────────────────
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary500,
        inactiveTrackColor: AppColors.primary100,
        thumbColor: AppColors.primary500,
        overlayColor: AppColors.primary500.withOpacity(0.12),
        valueIndicatorColor: AppColors.primary600,
        // valueIndicatorTextStyle: AppTextStyles.labelSmall.copyWith(
        //   color: AppColors.white,
        // ),
      ),

      // ── Icon ─────────────────────────────────────────────────────────────
      iconTheme: IconThemeData(color: colorScheme.onSurface, size: 24),
      primaryIconTheme: const IconThemeData(
        color: AppColors.primary500,
        size: 24,
      ),

      // ── PageTransitions ───────────────────────────────────────────────────
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
