import 'dart:developer' as developer;

import 'app.dart';

class AppInitializer {
  static Future<List<Override>> init() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      await Hive.initFlutter();

      Hive
        ..registerAdapter(ProfileModelAdapter())
        ..registerAdapter(PaymentModelAdapter())
        ..registerAdapter(OptionModelAdapter())
        ..registerAdapter(ChatRoleAdapter())
        ..registerAdapter(ChatMessageStatusAdapter())
        ..registerAdapter(ChatMessageAdapter());

      final results = await Future.wait([
        Hive.openBox<ProfileModel>('profile_box'),
        Hive.openBox<PaymentModel>('payment_box'),
        Hive.openBox<OptionModel>('option_box'),
        Hive.openBox<ChatMessage>('ai_box'),
      ]);

      return [
        profileBoxProvider.overrideWithValue(results[0] as Box<ProfileModel>),
        paymentBoxProvider.overrideWithValue(results[1] as Box<PaymentModel>),
        optionBoxProvider.overrideWithValue(results[2] as Box<OptionModel>),
        aiBoxProvider.overrideWithValue(results[3] as Box<ChatMessage>),
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
