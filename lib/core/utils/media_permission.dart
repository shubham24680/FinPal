import 'dart:io';

import 'package:finpal/core/packages/packages.dart';

/// Asks for camera or photos access right before the user picks an image.
abstract final class MediaPermission {
  /// Returns true when the OS has granted enough access to open [source].
  static Future<bool> ensure(ImageSource source) async {
    if (source == ImageSource.camera) {
      return _request(Permission.camera);
    }
    return _requestGallery();
  }

  static Future<bool> _requestGallery() async {
    if (await _isAllowed(Permission.photos)) return true;

    final photos = await Permission.photos.request();
    if (photos.isGranted || photos.isLimited) return true;

    // Android 12 and below use READ_EXTERNAL_STORAGE instead of
    // READ_MEDIA_IMAGES.
    if (Platform.isAndroid) {
      if (await _isAllowed(Permission.storage)) return true;
      final storage = await Permission.storage.request();
      return storage.isGranted;
    }

    return false;
  }

  static Future<bool> _request(Permission permission) async {
    if (await _isAllowed(permission)) return true;
    final result = await permission.request();
    return result.isGranted || result.isLimited;
  }

  static Future<bool> _isAllowed(Permission permission) async {
    final status = await permission.status;
    return status.isGranted || status.isLimited;
  }
}
