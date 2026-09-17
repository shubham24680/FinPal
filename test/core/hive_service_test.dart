import 'package:finpal/core/local_storage/hive_service.dart';
import 'package:finpal/features/settings/data/models/option_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import '../helpers/fixtures.dart';
import '../helpers/hive_test_setup.dart';

void main() {
  late Box<OptionModel> box;
  late HiveService<OptionModel> service;

  setUpAll(HiveTestSetup.ensureInitialized);

  setUp(() async {
    box = await HiveTestSetup.openBox<OptionModel>('hive_service');
    service = HiveService(box);
  });

  tearDown(() => HiveTestSetup.closeBox(box));

  tearDownAll(HiveTestSetup.disposeAll);

  group('HiveService', () {
    test('save and get round-trip a value', () async {
      final option = makeOption(id: 'o1', name: 'Food');

      await service.saveData('o1', option);

      expect(service.getData('o1')?.name, 'Food');
      expect(service.getAllData(), hasLength(1));
    });

    test('getData returns null for missing key (empty / waiting)', () {
      expect(service.getData('missing'), isNull);
      expect(service.getAllData(), isEmpty);
    });

    test('saveAllData writes multiple keys', () async {
      await service.saveAllData({
        'a': makeOption(id: 'a', name: 'A'),
        'b': makeOption(id: 'b', name: 'B'),
      });

      expect(service.getAllData(), hasLength(2));
    });

    test('clearData removes one key', () async {
      await service.saveData('o1', makeOption(id: 'o1'));
      await service.clearData('o1');

      expect(service.getData('o1'), isNull);
    });

    test('clearAllData empties the box', () async {
      await service.saveData('o1', makeOption(id: 'o1'));
      await service.saveData('o2', makeOption(id: 'o2'));
      await service.clearAllData();

      expect(service.getAllData(), isEmpty);
    });
  });
}
