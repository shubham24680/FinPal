import 'package:finpal/app/app.dart';

class ProfileContentModel {
  final String id;
  final String title;
  final String icon;
  final ColorSet color;
  final String value;
  final bool isCompleted;

  ProfileContentModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    this.value = "",
    this.isCompleted = false,
  });

  ProfileContentModel copyWith({
    String? id,
    String? title,
    String? icon,
    ColorSet? color,
    String? value,
  }) => ProfileContentModel(
    id: id ?? this.id,
    title: title ?? this.title,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    value: value ?? this.value,
  );
}