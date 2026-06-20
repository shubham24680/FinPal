import 'package:finpal/app/app.dart';

part 'option_model.g.dart';

@HiveType(typeId: 2)
class OptionModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String type;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String icon;
  @HiveField(4)
  final Color? color;

  OptionModel({
    String? id,
    required this.type,
    required this.name,
    this.icon = "",
    this.color,
  }) : id = id ?? Uuid().v4();

  OptionModel copyWith({
    String? id,
    String? type,
    String? name,
    String? icon,
    Color? color,
  }) => OptionModel(
    id: id ?? this.id,
    type: type ?? this.type,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    color: color ?? this.color,
  );
}
