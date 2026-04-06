import 'package:finpal/app/app.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
class ProfileModel extends HiveObject {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? gender;

  @HiveField(2)
  final String? dateOfBirth;

  @HiveField(3)
  final int profileImageIndex;

  @HiveField(4)
  final bool isFistTimeVisit;

  ProfileModel({
    this.name,
    this.gender,
    this.dateOfBirth,
    this.profileImageIndex = 0,
    this.isFistTimeVisit = true,
  });

  ProfileModel copyWith({
    String? name,
    String? gender,
    String? dateOfBirth,
    int? profileImageIndex,
    bool? isFistTimeVisit,
  }) => ProfileModel(
    name: name ?? this.name,
    gender: gender ?? this.gender,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    profileImageIndex: profileImageIndex ?? this.profileImageIndex,
    isFistTimeVisit: isFistTimeVisit ?? this.isFistTimeVisit,
  );
}
