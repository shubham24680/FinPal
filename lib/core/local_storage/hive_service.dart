import 'package:finpal/app/app.dart';

class HiveService<T> {
  final Box<T> _box;

  HiveService(this._box);

  T? getData(String key) => _box.get(key);
  List<T> getAllData() => _box.values.toList(growable: false);

  Future<void> saveData(String key, T value) => _box.put(key, value);
  Future<void> saveAllData(Map<dynamic, T> values) => _box.putAll(values);

  Future<void> clearData(String key) => _box.delete(key);
  Future<void> clearAllData() => _box.clear();
}
