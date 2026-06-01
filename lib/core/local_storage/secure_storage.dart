import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static SecureStorage? _instance;
  static SecureStorage get instance => _instance ??= SecureStorage._();
  SecureStorage._();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  Future<String?> get(String key) async => await _secureStorage.read(key: key);
  Future<void> set(String key, String value) async =>
      await _secureStorage.write(key: key, value: value);
  Future<void> delete(String key) async =>
      await _secureStorage.delete(key: key);
  Future<void> clear() async => await _secureStorage.deleteAll();
}
