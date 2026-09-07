import 'dart:developer' as developer;

import 'app.dart';

class AppInitializer {
  static final _settingsBox = "settings_box";
  static final _profileBox = "profile_box";
  static final _optionBox = "option_box";
  static final _paymentBox = "payment_box";

  static Future<List<Override>> init() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      await Hive.initFlutter();

      Hive
        ..registerAdapter(SettingsModelAdapter())
        ..registerAdapter(ProfileModelAdapter())
        ..registerAdapter(OptionModelAdapter())
        ..registerAdapter(PaymentModelAdapter());

      final results = await Future.wait([
        Hive.openBox<SettingsModel>(_settingsBox),
        Hive.openBox<ProfileModel>(_profileBox),
        Hive.openBox<OptionModel>(_optionBox),
        Hive.openBox<PaymentModel>(_paymentBox),
      ]);

      final profileBox = results[1] as Box<ProfileModel>;
      final paymentBox = results[3] as Box<PaymentModel>;

      // Runs before any screen exists, so nothing can be holding a picked
      // image that has not been saved yet.
      await ImageStorage.sweepOrphans([
        for (final profile in profileBox.values) profile.profileImage,
        for (final payment in paymentBox.values) payment.receiptPath,
      ]);

      return [
        settingsBoxProvider.overrideWithValue(results[0] as Box<SettingsModel>),
        profileBoxProvider.overrideWithValue(profileBox),
        optionBoxProvider.overrideWithValue(results[2] as Box<OptionModel>),
        paymentBoxProvider.overrideWithValue(paymentBox),
      ];
    } catch (error, stackTrace) {
      if (kDebugMode) {
        developer.log(
          'FinPal initialization failed',
          error: error,
          stackTrace: stackTrace,
        );
      }
      rethrow;
    }
  }
}
