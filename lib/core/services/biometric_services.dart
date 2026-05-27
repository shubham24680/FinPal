import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

enum AuthResult { success, failed, notAvailable }

class FingerprintServices {
  final LocalAuthentication _auth = LocalAuthentication();
  static FingerprintServices? _instance;
  FingerprintServices._();
  static FingerprintServices get instance =>
      _instance ??= FingerprintServices._();

  Future<bool> isDeviceSupported() async {
    try {
      final bool canCheckFingerprint = await _auth.canCheckBiometrics;
      final bool isSupported = await _auth.isDeviceSupported();
      return canCheckFingerprint || isSupported;
    } catch (_) {
      return false;
    }
  }

  Future<AuthResult> authenticate() async {
    try {
      final result = await _auth.authenticate(
        localizedReason: "Authenticate to access the app",
        options: const AuthenticationOptions(stickyAuth: true),
      );

      return result ? AuthResult.success : AuthResult.failed;
    } on PlatformException catch (e) {
      switch (e.code) {
        case auth_error.notAvailable:
        case auth_error.notEnrolled:
          return AuthResult.notAvailable;
        default:
          return AuthResult.failed;
      }
    }
  }
}
