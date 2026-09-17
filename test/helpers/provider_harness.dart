import 'package:finpal/features/settings/data/models/option_model.dart';
import 'package:finpal/features/settings/data/models/profile_model.dart';
import 'package:finpal/features/settings/data/models/settings_model.dart';
import 'package:finpal/features/settings/data/notifiers/options_provider.dart';
import 'package:finpal/features/settings/data/notifiers/profile_provider.dart';
import 'package:finpal/features/settings/data/notifiers/settings_notifier.dart';
import 'package:finpal/features/transaction/data/models/payment_model.dart';
import 'package:finpal/features/transaction/data/notifiers/transaction_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'hive_test_setup.dart';

/// Opens the four Hive boxes FinPal needs and returns Riverpod overrides.
class ProviderHarness {
  ProviderHarness._({
    required this.paymentBox,
    required this.optionBox,
    required this.profileBox,
    required this.settingsBox,
  });

  final Box<PaymentModel> paymentBox;
  final Box<OptionModel> optionBox;
  final Box<ProfileModel> profileBox;
  final Box<SettingsModel> settingsBox;

  static Future<ProviderHarness> create() async {
    await HiveTestSetup.ensureInitialized();
    return ProviderHarness._(
      paymentBox: await HiveTestSetup.openBox<PaymentModel>('payments'),
      optionBox: await HiveTestSetup.openBox<OptionModel>('options'),
      profileBox: await HiveTestSetup.openBox<ProfileModel>('profile'),
      settingsBox: await HiveTestSetup.openBox<SettingsModel>('settings'),
    );
  }

  List<Override> get overrides => [
        paymentBoxProvider.overrideWithValue(paymentBox),
        optionBoxProvider.overrideWithValue(optionBox),
        profileBoxProvider.overrideWithValue(profileBox),
        settingsBoxProvider.overrideWithValue(settingsBox),
      ];

  ProviderContainer createContainer({List<Override> extra = const []}) {
    return ProviderContainer(overrides: [...overrides, ...extra]);
  }

  Future<void> dispose() async {
    await HiveTestSetup.closeBox(paymentBox);
    await HiveTestSetup.closeBox(optionBox);
    await HiveTestSetup.closeBox(profileBox);
    await HiveTestSetup.closeBox(settingsBox);
  }
}
