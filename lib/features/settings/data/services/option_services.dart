import 'package:finpal/app/app.dart';

import 'dart:developer';

class OptionServices {
  final Box<OptionModel> box;
  late HiveService<OptionModel> _hiveService;

  OptionServices(this.box) {
    _hiveService = HiveService<OptionModel>(box);
  }

  List<OptionModel> get options => _hiveService.getAllData();
  OptionModel? findById(String id) {
    for (var option in options) {
      if (option.id == id) {
        return option;
      }
    }
    return null;
  }

  OptionModel? findByName(String name, String type) {
    for (var option in options) {
      if (option.name.toLowerCase() == name.toLowerCase() &&
          option.type == type) {
        return option;
      }
    }
    return null;
  }

  OptionModel? findByType(String type) {
    for (var option in options) {
      if (option.type == type) {
        return option;
      }
    }
    return null;
  }

  Future<void> save(OptionModel option) async {
    await _hiveService.saveData(option.id, option);
    log("Option saved: ${option.name}, ${option.id}");
  }

  Future<void> saveAll(List<OptionModel> newOptions) async {
    for (var option in newOptions) {
      await _hiveService.saveData(option.id, option);
    }
    log("Options saved: ${newOptions.length}");
  }

  Future<void> delete(String id) async {
    await _hiveService.clearData(id);
    log("Option deleted: $id");
  }

  List<OptionModel> byType(String type, {String? excludeId}) =>
      options.where((o) => o.type == type && o.id != excludeId).toList();

  List<OptionModel> get incomeCategories =>
      byType(OptionsConstant.incomeCategory);

  List<OptionModel> get expenseCategories =>
      byType(OptionsConstant.expenseCategory);

  List<OptionModel> get paymentMethods =>
      byType(OptionsConstant.paymentMethod);
}
