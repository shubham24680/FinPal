import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'app.dart';

class AppInitializer {
  static final _profileBox = "profile_box";
  static final _paymentBox = "payment_box";
  static final _optionBox = "option_box";
  static final _aiBox = "ai_box";
  static final pinBoxName = 'pin_box';
  static final hiveKeyAlias = 'hive_encryption_key';

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
        initPinBox(),
        Hive.openBox<ProfileModel>(_profileBox),
        Hive.openBox<PaymentModel>(_paymentBox),
        Hive.openBox<OptionModel>(_optionBox),
        Hive.openBox<ChatMessage>(_aiBox),
      ]);

      return [
        pinBoxProvider.overrideWithValue(results[0] as Box<String>),
        profileBoxProvider.overrideWithValue(results[1] as Box<ProfileModel>),
        paymentBoxProvider.overrideWithValue(results[2] as Box<PaymentModel>),
        optionBoxProvider.overrideWithValue(results[3] as Box<OptionModel>),
        aiBoxProvider.overrideWithValue(results[4] as Box<ChatMessage>),
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
