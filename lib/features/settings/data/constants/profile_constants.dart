import 'package:finpal/app/app.dart';

class ProfileConstants {
  static List<ProfileContentModel> profileContents = [
    ProfileContentModel(
      id: "full_name",
      title: "Full Name",
      icon: AppSvgs.userId,
      iconColor: AppColors.info500,
      iconBgColor: AppColors.info50,
      iconBgDarkColor: AppColors.info700.withAlpha(100),
    ),
    ProfileContentModel(
      id: "date_of_birth",
      title: "Date of Birth",
      icon: AppSvgs.calendar1,
      iconColor: AppColors.primary500,
      iconBgColor: AppColors.primary50,
      iconBgDarkColor: AppColors.primary700.withAlpha(100),
    ),
    ProfileContentModel(
      id: "gender",
      title: "Gender",
      icon: AppSvgs.user1,
      iconColor: AppColors.warning500,
      iconBgColor: AppColors.warning50,
      iconBgDarkColor: AppColors.warning700.withAlpha(100),
    ),
    ProfileContentModel(
      id: "monthly_income",
      title: "Monthly Income",
      icon: AppSvgs.rupee,
      iconColor: AppColors.purple500,
      iconBgColor: AppColors.purple50,
      iconBgDarkColor: AppColors.purple700.withAlpha(100),
    ),
  ];

  static final profileImageOptions = [
    ProfileContentModel(
      id: "camera",
      title: "Camera",
      icon: AppSvgs.camera,
      iconColor: AppColors.warning500,
      iconBgColor: AppColors.warning50,
    ),
    ProfileContentModel(
      id: "gallery",
      title: "Gallery",
      icon: AppSvgs.gallery,
      iconColor: AppColors.purple500,
      iconBgColor: AppColors.purple50,
    ),
  ];
}