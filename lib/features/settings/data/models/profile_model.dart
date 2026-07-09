import 'package:finpal/app/app.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 1)
class ProfileModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1, defaultValue: "")
  final String profileImage;
  @HiveField(2, defaultValue: "")
  final String name;
  @HiveField(3, defaultValue: "")
  final String dob;
  @HiveField(4, defaultValue: "")
  final String gender;
  @HiveField(5, defaultValue: "")
  final String email;
  @HiveField(6, defaultValue: "")
  final String phone;
  @HiveField(7)
  final double? monthlyIncome;
  @HiveField(8)
  final DateTime? createdAt;

  ProfileModel({
    String? id,
    DateTime? createdAt,
    this.profileImage = "",
    this.name = "",
    this.dob = "",
    this.gender = "",
    this.email = "",
    this.phone = "",
    this.monthlyIncome,
  }) : id = id ?? Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  ProfileModel copyWith({
    String? name,
    String? profileImage,
    String? dob,
    String? gender,
    String? email,
    String? phone,
    double? monthlyIncome,
  }) => ProfileModel(
    id: id,
    name: name ?? this.name,
    profileImage: profileImage ?? this.profileImage,
    dob: dob ?? this.dob,
    gender: gender ?? this.gender,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    monthlyIncome: monthlyIncome ?? this.monthlyIncome,
  );
}

class ProfileContentModel {
  final String id;
  final String title;
  final String icon;
  final Color iconColor;
  final Color iconBgColor;
  final Color? iconBgDarkColor;
  final String value;

  ProfileContentModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.iconBgDarkColor,
    this.value = "",
  });

  ProfileContentModel copyWith({
    String? id,
    String? title,
    String? icon,
    Color? iconColor,
    Color? iconBgColor,
    String? value,
    Color? iconBgDarkColor,
  }) => ProfileContentModel(
    id: id ?? this.id,
    title: title ?? this.title,
    icon: icon ?? this.icon,
    iconColor: iconColor ?? this.iconColor,
    iconBgColor: iconBgColor ?? this.iconBgColor,
    iconBgDarkColor: iconBgDarkColor ?? this.iconBgDarkColor,
    value: value ?? this.value,
  );
}