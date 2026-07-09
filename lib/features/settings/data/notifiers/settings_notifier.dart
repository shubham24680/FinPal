import 'package:finpal/app/app.dart';

final settingsBoxProvider = Provider<Box<SettingsModel>>(
  (ref) => throw UnimplementedError(),
);

class SettingsNotifier extends AsyncNotifier<SettingsModel> {
  late HiveService<SettingsModel> _hiveService;
  static const _key = 'settings';

  @override
  Future<SettingsModel> build() async {
    final box = ref.watch(settingsBoxProvider);
    _hiveService = HiveService(box);
    return _hiveService.getData(_key) ?? SettingsModel();
  }

  Future<void> save({
    bool? isFirstVisit,
    bool? isFingerprintEnabled,
    bool? isPasscodeEnabled,
    CurrencyContants? currency,
    ThemeMode? themeMode,
    bool? hideBalanceOnHome,
    bool? dailyReminderEnabled,
    DateTime? dailyReminderTime,
    double? monthlyBudget,
    bool? aiInsightsEnabled,
  }) async {
    state = const AsyncLoading();
    final settings = state.value ?? SettingsModel();
    state = await AsyncValue.guard(() async {
      final settingsModel = settings.copyWith(
        isFirstVisit: isFirstVisit,
        isFingerprintEnabled: isFingerprintEnabled,
        isPasscodeEnabled: isPasscodeEnabled,
        currencyCode: currency?.currency,
        currencySymbol: currency?.symbol,
        languageCode: currency?.locale,
        themeMode: themeMode?.name,
          hideBalanceOnHome: hideBalanceOnHome,
        dailyReminderEnabled: dailyReminderEnabled,
        dailyReminderTime: dailyReminderTime,
        monthlyBudget: monthlyBudget,
        aiInsightsEnabled: aiInsightsEnabled,
      );

      await _hiveService.saveData(_key, settingsModel);
      return settingsModel;
    });
  }
}

final settingsNotifier = AsyncNotifierProvider<SettingsNotifier, SettingsModel>(() => SettingsNotifier());

// THEME
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

// CURRENCY

CurrencyContants _currencyFromString(String? value) {
  return CurrencyContants.values.firstWhere(
    (currency) => currency.currency == value,
    orElse: () => CurrencyContants.rupee,
  );
}

final currencyProvider = Provider<CurrencyContants>((ref) {
  final settings = ref.watch(settingsNotifier);
  return settings.when(
    data: (settings) => _currencyFromString(settings.currencyCode),
    error: (error, stackTrace) => CurrencyContants.rupee,
    loading: () => CurrencyContants.rupee,
  );
});