import 'package:finpal/app/app.dart';

part 'option_model.g.dart';

@HiveType(typeId: 2)
class OptionModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1, defaultValue: "")
  final String type;
  @HiveField(2, defaultValue: "")
  final String name;
  @HiveField(3, defaultValue: "")
  final String icon;
  @HiveField(4, defaultValue: "")
  final String color;

  OptionModel({
    String? id,
    required this.type,
    required this.name,
    this.icon = "",
    this.color = "",
  }) : id = (id == null || id.isEmpty) ? Uuid().v4() : id;

  OptionModel copyWith({
    String? id,
    String? type,
    String? name,
    String? icon,
    String? color,
  }) => OptionModel(
    id: id ?? this.id,
    type: type ?? this.type,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    color: color ?? this.color,
  );
}
