import 'package:finpal/app/app.dart';

part 'profile_model.g.dart';

@HiveType(typeId: 0)
class ProfileModel extends HiveObject {
  @HiveField(0)
  final String? name;
  @HiveField(1)
  final int profileImageIndex;
  @HiveField(2)
  final bool isFirstTimeVisit;

  ProfileModel({
    this.name,
    this.profileImageIndex = 0,
    this.isFirstTimeVisit = true,
  });

  ProfileModel copyWith({
    String? name,
    int? profileImageIndex,
    bool? isFirstTimeVisit,
  }) => ProfileModel(
    name: name ?? this.name,
    profileImageIndex: profileImageIndex ?? this.profileImageIndex,
    isFirstTimeVisit: isFirstTimeVisit ?? this.isFirstTimeVisit,
  );
}
