import 'package:finpal/app/app.dart';

class ProfileConstants {
  static List<ProfileContentModel> profileContents = [
    ProfileContentModel(
      id: "full_name",
      title: "Full Name",
      icon: AppSvgs.userId,
      color: ColorSet.info,
    ),
    ProfileContentModel(
      id: "date_of_birth",
      title: "Date of Birth",
      icon: AppSvgs.calendar1,
      color: ColorSet.primary,
    ),
    ProfileContentModel(
      id: "gender",
      title: "Gender",
      icon: AppSvgs.user1,
      color: ColorSet.warning,
    ),
    ProfileContentModel(
      id: "monthly_income",
      title: "Monthly Income",
      icon: AppSvgs.rupee,
      color: ColorSet.purple,
    ),
  ];

  static final profileImageOptions = [
    ProfileContentModel(
      id: "camera",
      title: "Camera",
      icon: AppSvgs.camera,
      color: ColorSet.warning,
    ),
    ProfileContentModel(
      id: "gallery",
      title: "Gallery",
      icon: AppSvgs.gallery,
      color: ColorSet.purple,
    ),
  ];

  static List<ProfileContentModel> buildProgressSteps(
    ProfileModel profile,
    bool isFirstVisit,
  ) {
    final editRoute = AppRoutesPath.editProfile.path;
    return [
      ProfileContentModel(
        id: "getting_started",
        title: "Getting started",
        icon: AppSvgs.checkCircle,
        color: ColorSet.neutral,
        isCompleted: !isFirstVisit,
      ),
      ProfileContentModel(
        id: "name",
        title: "Add your name",
        icon: AppSvgs.userId,
        color: ColorSet.info,
        isCompleted: profile.name.isNotEmpty,
        value: editRoute,
      ),
      ProfileContentModel(
        id: "photo",
        title: "Add a profile photo",
        icon: AppSvgs.camera,
        color: ColorSet.warning,
        isCompleted: profile.profileImage.isNotEmpty,
        value: editRoute,
      ),
      ProfileContentModel(
        id: "personal_details",
        title: "Complete personal details",
        icon: AppSvgs.user1,
        color: ColorSet.purple,
        isCompleted: profile.dob.isNotEmpty && profile.gender.isNotEmpty,
        value: editRoute,
      ),
      ProfileContentModel(
        id: "income",
        title: "Set your monthly income",
        icon: AppSvgs.rupee,
        color: ColorSet.primary,
        isCompleted: (profile.monthlyIncome ?? 0) > 0,
        value: editRoute,
      ),
    ];
  }

  static ProfileContentModel statusLabel(int percent) {
    if (percent >= 100) {
      return ProfileContentModel(
        id: "all_set",
        title: "All set",
        icon: AppSvgs.checkCircle,
        color: ColorSet.primary,
      );
    }
    if (percent >= 80) {
      return ProfileContentModel(
        id: "almost_done",
        title: "Almost done",
        icon: AppSvgs.checkCircle,
        color: ColorSet.warning,
      );
    }
    if (percent >= 40) {
      return ProfileContentModel(
        id: "getting_there",
        title: "Getting there",
        icon: AppSvgs.checkCircle,
        color: ColorSet.neutral,
      );
    }
    return ProfileContentModel(
      id: "just_started",
      title: "Just started",
      icon: AppSvgs.checkCircle,
      color: ColorSet.neutral,
    );
  }

  static String message(int percent, String name) {
    final firstName = name.trim().split(' ').first;
    final hasName = firstName.isNotEmpty;

    if (percent >= 100) {
      return hasName ? "You're all set, $firstName!" : "You're all set!";
    }
    if (percent >= 80) {
      return hasName
          ? "Keep up your good work, $firstName!"
          : "Keep up your good work!";
    }
    if (percent >= 40) {
      return "You're making progress — keep going!";
    }
    return "Add your details to personalize your experience";
  }
}
