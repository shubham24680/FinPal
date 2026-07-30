import 'package:finpal/app/app.dart';

import 'dart:developer';

class OptionServices {
  final HiveService<OptionModel> _hiveService;
  List<OptionModel>? _cache;

  OptionServices(Box<OptionModel> box)
    : _hiveService = HiveService<OptionModel>(box);

  // CRUD Operations
  Future<void> save(OptionModel option) async {
    await _hiveService.saveData(option.id, option);
    clearCache();
    log("Option saved: ${option.name}, ${option.id}");
  }

  Future<void> saveAll(List<OptionModel> newOptions) async {
    if (newOptions.isEmpty) return;
    await _hiveService.saveAllData({for (final o in newOptions) o.id: o});
    clearCache();
    log("Options saved: ${newOptions.length}");
  }

  Future<void> delete(String id) async {
    await _hiveService.clearData(id);
    clearCache();
    log("Option deleted: $id");
  }

  void clearCache() => _cache = null;

  // Getters
  List<OptionModel> get categories => _cache ??= _hiveService.getAllData();
  List<OptionModel> get incomeCategories => byType(OptionType.income.id);
  List<OptionModel> get expenseCategories => byType(OptionType.expense.id);
  List<OptionModel> get paymentMethods => byType(OptionType.paymentMethod.id);

  //Filters
  OptionModel findById(String id) => _hiveService.getData(id) ?? OptionsConstant.otherCategory;
  
  OptionModel findByName(String name, String type) {
    final normalized = name.trim().toLowerCase();
    if (normalized.isEmpty) return OptionsConstant.otherCategory;
    for (var option in categories) {
      if (option.type == type && option.name.toLowerCase() == normalized) {
        return option;
      }
    }
    return OptionsConstant.otherCategory;
  }

  List<OptionModel> byType(String type, {String? excludeId}) => categories
      .where((o) => o.type == type && o.id != excludeId)
      .toList(growable: false);
}
