import 'package:finpal/app/app.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: BGColors.shade50,
    canvasColor: Colors.transparent,
    appBarTheme: AppBarTheme(
      backgroundColor: BGColors.shade500,
      surfaceTintColor: BGColors.shade500,
      centerTitle: true,
    ),
    colorScheme: ColorScheme.light(
      primary: PrimaryColors.shade500,
      secondary: SecondaryColors.shade50,
      tertiary: TextColors.shade900,
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: PrimaryColors.shade500.withAlpha(70),
      selectionHandleColor: PrimaryColors.shade500,
      cursorColor: PrimaryColors.shade500,
    ),
    textTheme: TextTheme(),
  );
}
