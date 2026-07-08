import 'package:finpal/app/app.dart';

ThemeMode _themeModeFromString(String? value) {
  return ThemeMode.values.firstWhere(
    (mode) => mode.name == value,
    orElse: () => ThemeMode.system,
  );
}

final themeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(settingsNotifier);
  return settings.when(
    data: (settings) => _themeModeFromString(settings.themeMode),
    error: (error, stackTrace) => ThemeMode.system,
    loading: () => ThemeMode.system,
  );
});
