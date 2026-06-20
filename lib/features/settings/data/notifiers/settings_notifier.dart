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
    String? currencyCode,
    String? currencySymbol,
    String? languageCode,
    String? themeMode,
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
        currencyCode: currencyCode,
        currencySymbol: currencySymbol,
        languageCode: languageCode,
        themeMode: themeMode,
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