import 'package:finpal/app/app.dart';

import 'dart:developer';

class OptionServices {
  final Box<OptionModel> box;
  late HiveService<OptionModel> _hiveService;
  List<OptionModel> options = [];

  OptionServices(this.box) {
    _hiveService = HiveService<OptionModel>(box);
    options = _hiveService.getAllData();
  }

  Future<void> save(OptionModel option) async {
    await _hiveService.saveData(option.id, option);
    options = [...options, option];
    log("Option saved: ${option.name}, ${option.id}");
  }

  Future<void> saveAll(List<OptionModel> newOptions) async {
    for (var option in newOptions) {
      await _hiveService.saveData(option.id, option);
    }
    options = [...options, ...newOptions];
    log("Options saved: ${newOptions.length}");
  }

  List<OptionModel> byType(String type) =>
      options.where((o) => o.type == type).toList();

  List<OptionModel> get incomeCategories =>
      byType(OnboardingConstants.incomeCategory);

  List<OptionModel> get expenseCategories =>
      byType(OnboardingConstants.expenseCategory);

  List<OptionModel> get paymentMethods =>
      byType(OnboardingConstants.paymentMethod);

  OptionModel? findById(String id) =>
      options.where((o) => o.id == id).firstOrNull;
}
