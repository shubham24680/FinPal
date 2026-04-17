import 'app.dart';

class AppInitializer {
  static Future<List<Override>> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Hive.initFlutter();

    Hive
      ..registerAdapter(ProfileModelAdapter())
      ..registerAdapter(PaymentModelAdapter())
      ..registerAdapter(OptionModelAdapter());

    final results = await Future.wait([
      Hive.openBox<ProfileModel>('profile_box'),
      Hive.openBox<PaymentModel>('payment_box'),
      Hive.openBox<OptionModel>('option_box'),
    ]);

    return [
      profileBoxProvider.overrideWithValue(results[0] as Box<ProfileModel>),
      paymentBoxProvider.overrideWithValue(results[1] as Box<PaymentModel>),
      optionBoxProvider.overrideWithValue(results[2] as Box<OptionModel>),
    ];
  }
}
