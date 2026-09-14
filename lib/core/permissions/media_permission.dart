import 'dart:io';
import 'package:finpal/app/app.dart';

abstract final class MediaPermission {
  static Future<bool> ensure(ImageSource source) async {
    return switch (source) {
      ImageSource.camera => await _request(Permission.camera),
      ImageSource.gallery => await _requestGallery(),
    };
  }

  static Future<bool> _request(Permission permission) async {
    final isAllowed = await _isAllowed(permission);
    if (isAllowed) return true;
    final status = await permission.request();
    return status.isGranted || status.isLimited;
  }

  static Future<bool> _isAllowed(Permission permission) async {
    final status = await permission.status;
    return status.isGranted || status.isLimited;
  }

  static Future<bool> _requestGallery() async {
    if (Platform.isIOS) return _request(Permission.photos);

    if (await _request(Permission.photos)) return true;
    return _request(Permission.storage);
  }
}
