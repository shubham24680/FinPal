import 'package:finpal/app/app.dart';

part 'option_model.g.dart';

@HiveType(typeId: 4)
class OptionModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String icon;
  @HiveField(2)
  final String? screenPath;

  const OptionModel({required this.name, required this.icon, this.screenPath});
}
