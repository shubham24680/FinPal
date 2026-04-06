import 'app.dart';

class AppInitializer {
  static Future<List<Override>> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Hive.initFlutter();

    // Register all Hive adapters
    Hive
      ..registerAdapter(ProfileModelAdapter())
      ..registerAdapter(TransactionModelAdapter())
      ..registerAdapter(PaymentModelAdapter())
      ..registerAdapter(OptionModelAdapter());

    // Open all boxes in parallel
    final results = await Future.wait([
      Hive.openBox<ProfileModel>('profile_box'),
      Hive.openBox<TransactionModel>('transaction_box'),
    ]);

    return [
      profileBoxProvider.overrideWithValue(results[0] as Box<ProfileModel>),
      transactionBoxProvider.overrideWithValue(
        results[1] as Box<TransactionModel>,
      ),
    ];
  }
}
