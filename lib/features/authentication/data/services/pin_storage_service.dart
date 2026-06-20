import 'dart:convert';
import 'package:finpal/app/app.dart';
import 'package:crypto/crypto.dart';

class PinStorageService {
  static const _pinHashKey = 'pin_hash';
  static const _pinSaltKey = 'pin_salt';
  final Box<String> pinBox;
  late HiveService<String> _hiveService;
  PinStorageService(this.pinBox) {
    _hiveService = HiveService<String>(pinBox);
  }

  String _generateSalt() {
    final key = Hive.generateSecureKey();
    final salt = base64Url.encode(key);
    return salt;
  }

  String _generateHash(String pin, String salt) {
    final bytes = utf8.encode(pin + salt);
    final digest = sha256.convert(bytes).toString();
    return digest;
  }

  Future<bool> savePin(String pin) async {
    try {
      final salt = _generateSalt();
      final hash = _generateHash(pin, salt);

      await _hiveService.saveData(_pinSaltKey, salt);
      await _hiveService.saveData(_pinHashKey, hash);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool verifyPin(String pin) {
    final salt = _hiveService.getData(_pinSaltKey);
    final hash = _hiveService.getData(_pinHashKey);
    if (salt == null || hash == null) return false;

    final newHash = _generateHash(pin, salt);
    return hash == newHash;
  }
}
