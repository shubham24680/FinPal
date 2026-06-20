import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'app.dart';

class AppInitializer {
  static final _settingsBox = "settings_box";
  static final _profileBox = "profile_box";
  static final _optionBox = "option_box";
  static final _paymentBox = "payment_box";
  static final _aiBox = "ai_box";
  static final pinBoxName = 'pin_box';
  static final hiveKeyAlias = 'hive_encryption_key';

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
        initPinBox(),
        Hive.openBox<SettingsModel>(_settingsBox),
        Hive.openBox<ProfileModel>(_profileBox),
        Hive.openBox<OptionModel>(_optionBox),
        Hive.openBox<PaymentModel>(_paymentBox),
        Hive.openBox<ChatMessage>(_aiBox),
      ]);

      return [
        pinBoxProvider.overrideWithValue(results[0] as Box<String>),
        settingsBoxProvider.overrideWithValue(results[1] as Box<SettingsModel>),
        profileBoxProvider.overrideWithValue(results[2] as Box<ProfileModel>),
        optionBoxProvider.overrideWithValue(results[3] as Box<OptionModel>),
        paymentBoxProvider.overrideWithValue(results[4] as Box<PaymentModel>),
        aiBoxProvider.overrideWithValue(results[5] as Box<ChatMessage>),
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

  static Future<Box<String>> initPinBox() async {
    final secureStorage = SecureStorage.instance;
    String? existingKey = await secureStorage.get(hiveKeyAlias);
    Uint8List encryptionKey;

    if (existingKey == null) {
      encryptionKey = Uint8List.fromList(Hive.generateSecureKey());
      await secureStorage.set(hiveKeyAlias, base64Url.encode(encryptionKey));
    } else {
      encryptionKey = base64Url.decode(existingKey);
    }

    return await Hive.openBox<String>(
      pinBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }
}
