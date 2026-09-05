import 'dart:developer' as developer;

import 'app.dart';

class AppInitializer {
  static final _settingsBox = "settings_box";
  static final _profileBox = "profile_box";
  static final _optionBox = "option_box";
  static final _paymentBox = "payment_box";
  static final _aiBox = "ai_box";

  static Future<List<Override>> init() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      await Hive.initFlutter();

      Hive
        ..registerAdapter(SettingsModelAdapter())
        ..registerAdapter(ProfileModelAdapter())
        ..registerAdapter(OptionModelAdapter())
        ..registerAdapter(PaymentModelAdapter())
        ..registerAdapter(ChatRoleAdapter())
        ..registerAdapter(ChatMessageStatusAdapter())
        ..registerAdapter(ChatMessageAdapter());

      final results = await Future.wait([
        Hive.openBox<SettingsModel>(_settingsBox),
        Hive.openBox<ProfileModel>(_profileBox),
        Hive.openBox<OptionModel>(_optionBox),
        Hive.openBox<PaymentModel>(_paymentBox),
        Hive.openBox<ChatMessage>(_aiBox),
      ]);

      return [
        settingsBoxProvider.overrideWithValue(results[0] as Box<SettingsModel>),
        profileBoxProvider.overrideWithValue(results[1] as Box<ProfileModel>),
        optionBoxProvider.overrideWithValue(results[2] as Box<OptionModel>),
        paymentBoxProvider.overrideWithValue(results[3] as Box<PaymentModel>),
        // aiBoxProvider.overrideWithValue(results[4] as Box<ChatMessage>),
      ];
    } catch (error, stackTrace) {
      developer.log(
        'FinPal initialization failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
