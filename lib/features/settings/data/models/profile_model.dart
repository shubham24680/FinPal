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
  }) : id = (id == null || id.isEmpty) ? Uuid().v4() : id,
       createdAt = createdAt ?? DateTime.now();

  ProfileModel copyWith({
    String? name,
    String? profileImage,
    String? dob,
    String? gender,
    String? email,
    String? phone,
    double? monthlyIncome,
    bool clearMonthlyIncome = false,
  }) => ProfileModel(
    id: id,
    createdAt: createdAt,
    name: name ?? this.name,
    profileImage: profileImage ?? this.profileImage,
    dob: dob ?? this.dob,
    gender: gender ?? this.gender,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    monthlyIncome:
        clearMonthlyIncome ? null : monthlyIncome ?? this.monthlyIncome,
  );
}