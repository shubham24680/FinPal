import 'dart:io';

import 'package:finpal/features/settings/data/models/option_model.dart';
import 'package:finpal/features/settings/data/models/profile_model.dart';
import 'package:finpal/features/settings/data/models/settings_model.dart';
import 'package:finpal/features/transaction/data/models/payment_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

/// Shared Hive bootstrap for unit/provider tests.
class HiveTestSetup {
  HiveTestSetup._();

  static Directory? _tempDir;
  static var _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    TestWidgetsFlutterBinding.ensureInitialized();
    _tempDir = await Directory.systemTemp.createTemp('finpal_hive_test_');
    Hive.init(_tempDir!.path);
    _registerAdapters();
    _initialized = true;
  }

  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SettingsModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProfileModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(OptionModelAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(PaymentModelAdapter());
    }
  }

  static Future<Box<T>> openBox<T>(String prefix) {
    return Hive.openBox<T>(
      '${prefix}_${DateTime.now().microsecondsSinceEpoch}',
    );
  }

  static Future<void> closeBox(Box box) async {
    if (box.isOpen) {
      await box.clear();
      await box.close();
    }
  }

  static Future<void> disposeAll() async {
    await Hive.close();
    final dir = _tempDir;
    _tempDir = null;
    _initialized = false;
    if (dir != null && dir.existsSync()) {
      await dir.delete(recursive: true);
    }
  }
}
