import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Owns the images the user picks for avatars and receipts.
///
/// [ImagePicker] hands back a path inside the OS cache directory, which Android
/// reclaims under storage pressure. Persisting that path directly means the
/// image silently disappears later, so every picked file is copied in here
/// first and only the copy's path is ever stored.
abstract final class ImageStorage {
  static const _folderName = 'user_images';

  static Future<Directory> _folder() async {
    final documents = await getApplicationDocumentsDirectory();
    final folder = Directory('${documents.path}/$_folderName');
    return folder.existsSync() ? folder : await folder.create(recursive: true);
  }

  /// Copies [cachePath] into permanent storage and returns the new path, or
  /// null if the copy failed so the caller can report it instead of storing a
  /// path that will not survive.
  static Future<String?> persist(String cachePath) async {
    try {
      final source = File(cachePath);
      if (!source.existsSync()) return null;

      final folder = await _folder();
      final copy = await source.copy('${folder.path}/${_fileName(cachePath)}');
      return copy.path;
    } catch (_) {
      return null;
    }
  }

  /// Deletes a file previously returned by [persist]. Paths outside the managed
  /// folder are ignored so nothing this class does not own can be removed.
  static Future<void> discard(String? path) async {
    if (path == null || path.isEmpty) return;
    try {
      final folder = await _folder();
      if (!path.startsWith('${folder.path}/')) return;

      final file = File(path);
      if (file.existsSync()) await file.delete();
    } catch (_) {}
  }

  /// Deletes managed files that no stored record points at any more, covering
  /// images picked and then abandoned by cancelling out of an edit screen.
  ///
  /// Only safe at startup, before any screen can be holding a picked image that
  /// has not been saved yet.
  static Future<void> sweepOrphans(Iterable<String> referenced) async {
    try {
      final folder = await _folder();
      final keep = referenced.where((path) => path.isNotEmpty).toSet();

      await for (final entity in folder.list()) {
        if (entity is File && !keep.contains(entity.path)) {
          await entity.delete();
        }
      }
    } catch (_) {}
  }

  /// Removes the entire managed image folder. Used when recovering from a
  /// corrupted local store that cannot be opened.
  static Future<void> clearAll() async {
    try {
      final documents = await getApplicationDocumentsDirectory();
      final folder = Directory('${documents.path}/$_folderName');
      if (folder.existsSync()) {
        await folder.delete(recursive: true);
      }
    } catch (_) {}
  }

  static String _fileName(String sourcePath) {
    final name = sourcePath.replaceAll('\\', '/').split('/').last;
    final dot = name.lastIndexOf('.');
    final extension = dot == -1 ? '' : name.substring(dot).toLowerCase();
    return '${const Uuid().v4()}$extension';
  }
}
