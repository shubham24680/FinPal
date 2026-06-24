import 'package:finpal/app/app.dart';

class ProfileConstants {
  static List<ProfileContentModel> profileContents = [
    ProfileContentModel(
      id: "full_name",
      title: "Full Name",
      icon: AppSvgs.user,
      iconColor: AppColors.info500,
      iconBgColor: AppColors.info50,
    ),
    ProfileContentModel(
      id: "date_of_birth",
      title: "Date of Birth",
      icon: AppSvgs.calendar,
      iconColor: AppColors.primary500,
      iconBgColor: AppColors.primary50,
    ),
    ProfileContentModel(
      id: "gender",
      title: "Gender",
      icon: AppSvgs.user1,
      iconColor: AppColors.warning500,
      iconBgColor: AppColors.warning50,
    ),
  ];
}