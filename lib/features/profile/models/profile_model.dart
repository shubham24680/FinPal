import 'package:finpal/app/app.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
class ProfileModel extends HiveObject {
  @HiveField(0)
  final String? name;
  @HiveField(1, defaultValue: 0)
  final int profileImageIndex;
  @HiveField(2, defaultValue: true)
  final bool isFirstTimeVisit;
  @HiveField(3, defaultValue: false)
  final bool isFingerprintEnabled;

  ProfileModel({
    this.name,
    this.profileImageIndex = 0,
    this.isFirstTimeVisit = true,
    this.isFingerprintEnabled = false,
  });

  ProfileModel copyWith({
    String? name,
    int? profileImageIndex,
    bool? isFirstTimeVisit,
    bool? isFingerprintEnabled,
  }) => ProfileModel(
    name: name ?? this.name,
    profileImageIndex: profileImageIndex ?? this.profileImageIndex,
    isFirstTimeVisit: isFirstTimeVisit ?? this.isFirstTimeVisit,
    isFingerprintEnabled: isFingerprintEnabled ?? this.isFingerprintEnabled,
  );
}
