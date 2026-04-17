import 'package:finpal/app/app.dart';

class HiveService<T> {
  final Box<T> _box;

  HiveService(this._box);

  T? getData(String key) => _box.get(key);
  List<T> getAllData() => _box.values.toList(growable: false);

  Future<void> saveData(String key, T value) => _box.put(key, value);

  Future<void> clearData(String key) => _box.delete(key);
  Future<void> clearAllData() => _box.clear();
}
