import 'dart:io';

import 'package:finpal/core/utils/image_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  _FakePathProvider(this.documentsPath);

  final String documentsPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => documentsPath;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory documents;
  late Directory cache;

  setUp(() async {
    documents = await Directory.systemTemp.createTemp('finpal_documents');
    cache = await Directory.systemTemp.createTemp('finpal_cache');
    PathProviderPlatform.instance = _FakePathProvider(documents.path);
  });

  tearDown(() async {
    for (final directory in [documents, cache]) {
      if (directory.existsSync()) await directory.delete(recursive: true);
    }
  });

  Future<File> pickedImage(String name) async {
    final file = File('${cache.path}/$name');
    await file.writeAsBytes(List.filled(64, 1));
    return file;
  }

  group('ImageStorage.persist', () {
    test('copies the picked file out of the cache directory', () async {
      final picked = await pickedImage('receipt.jpg');

      final stored = await ImageStorage.persist(picked.path);

      expect(stored, isNotNull);
      expect(File(stored!).existsSync(), isTrue);
      expect(stored.startsWith(documents.path), isTrue);
      // The original must survive independently of the copy.
      expect(picked.existsSync(), isTrue);
    });

    test('keeps the file extension so validation still passes', () async {
      final picked = await pickedImage('receipt.PNG');

      final stored = await ImageStorage.persist(picked.path);

      expect(stored, endsWith('.png'));
    });

    test('gives each copy a unique name', () async {
      final picked = await pickedImage('receipt.jpg');

      final first = await ImageStorage.persist(picked.path);
      final second = await ImageStorage.persist(picked.path);

      expect(first, isNot(second));
      expect(File(first!).existsSync(), isTrue);
      expect(File(second!).existsSync(), isTrue);
    });

    test('returns null when the source is gone', () async {
      final stored = await ImageStorage.persist('${cache.path}/missing.jpg');

      expect(stored, isNull);
    });
  });

  group('ImageStorage.discard', () {
    test('deletes a file it owns', () async {
      final picked = await pickedImage('avatar.jpg');
      final stored = await ImageStorage.persist(picked.path);

      await ImageStorage.discard(stored);

      expect(File(stored!).existsSync(), isFalse);
    });

    test('leaves files outside the managed folder alone', () async {
      final outsider = await pickedImage('not_ours.jpg');

      await ImageStorage.discard(outsider.path);

      expect(outsider.existsSync(), isTrue);
    });

    test('ignores empty and null paths', () async {
      await expectLater(ImageStorage.discard(null), completes);
      await expectLater(ImageStorage.discard(''), completes);
    });
  });

  group('ImageStorage.sweepOrphans', () {
    test('removes files nothing references and keeps the rest', () async {
      final picked = await pickedImage('receipt.jpg');
      final referenced = await ImageStorage.persist(picked.path);
      final orphan = await ImageStorage.persist(picked.path);

      await ImageStorage.sweepOrphans([referenced!, '']);

      expect(File(referenced).existsSync(), isTrue);
      expect(File(orphan!).existsSync(), isFalse);
    });
  });
}
