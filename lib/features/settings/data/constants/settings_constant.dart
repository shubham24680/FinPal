import 'package:finpal/app/app.dart';

class SettingsConstants {
  static List<SettingsContentModel> accountContents = [
    SettingsContentModel(
      id: "personal_information",
      title: "Personal Information",
      icon: AppSvgs.userId,
      iconColor: AppColors.info500,
      iconBgColor: AppColors.info50,
      iconBgDarkColor: AppColors.info700.withAlpha(100),
      path: AppRoutesPath.editProfile.path,
    ),
    SettingsContentModel(
      id: "manage_categories",
      title: "Manage Categories",
      icon: AppSvgs.category,
      iconColor: AppColors.info500,
      iconBgColor: AppColors.info50,
      iconBgDarkColor: AppColors.info700.withAlpha(100),
      path: AppRoutesPath.options.path,
    )
  ];

  static List<SettingsContentModel> appearanceContents = [
    SettingsContentModel(
      id: "theme",
      title: "Theme",
      icon: AppSvgs.theme,
      iconColor: AppColors.purple500,
      iconBgColor: AppColors.purple50,
      iconBgDarkColor: AppColors.purple700.withAlpha(100),
      path: AppRoutesPath.theme.path,
    ),
  ];

  static List<SettingsContentModel> securityContents = [
    SettingsContentModel(
      id: "change_passcode",
      title: "Change Passcode",
      icon: AppSvgs.lock,
      iconColor: AppColors.warning500,
      iconBgColor: AppColors.warning50,
      iconBgDarkColor: AppColors.warning700.withAlpha(100),
    ),
    SettingsContentModel(
      id: "fingerprint_authentication",
      title: "Fingerprint Authentication",
      icon: AppSvgs.fingerprint,
      iconColor: AppColors.warning500,
      iconBgColor: AppColors.warning50,
      iconBgDarkColor: AppColors.warning700.withAlpha(100),
      actionType: ActionType.toggle,
    ),
    SettingsContentModel(
      id: "hide_balance",
      title: "Hide Balance",
      icon: AppSvgs.other,
      iconColor: AppColors.warning500,
      iconBgColor: AppColors.warning50,
      iconBgDarkColor: AppColors.warning700.withAlpha(100),
      actionType: ActionType.toggle,
    ),
  ];

  static List<SettingsContentModel> preferencesContents = [
    SettingsContentModel(
      id: "currency",
      title: "Currency",
      icon: AppSvgs.money,
      iconColor: AppColors.primary500,
      iconBgColor: AppColors.primary50,
      iconBgDarkColor: AppColors.primary700.withAlpha(100),
      path: AppRoutesPath.currency.path,
    ),
    SettingsContentModel(
      id: "hide_balance",
      title: "Hide Balance",
      icon: AppSvgs.cash,
      iconColor: AppColors.primary500,
      iconBgColor: AppColors.primary50,
      iconBgDarkColor: AppColors.primary700.withAlpha(100),
      actionType: ActionType.toggle,
    ),
  ];

  static List<SettingsContentModel> aboutContents = [
    SettingsContentModel(
      id: "privacy_policy",
      title: "Privacy Policy",
      icon: AppSvgs.privacy,
      iconColor: AppColors.neutral500,
      iconBgColor: AppColors.neutral50,
      iconBgDarkColor: AppColors.neutral700.withAlpha(100),
      actionType: ActionType.launchUrl,
      path: "https://shubham24680.github.io/policy/finpal-privacy-policy.html",
    ),
    SettingsContentModel(
      id: "terms_and_conditions",
      title: "Terms and Conditions",
      icon: AppSvgs.terms,
      iconColor: AppColors.neutral500,
      iconBgColor: AppColors.neutral50,
      iconBgDarkColor: AppColors.neutral700.withAlpha(100),
      actionType: ActionType.launchUrl,
      path: "https://shubham24680.github.io/policy/finpal-terms-and-conditions.html",
    ),
    SettingsContentModel(
      id: "support",
      title: "Help & Support",
      icon: AppSvgs.help,
      iconColor: AppColors.neutral500,
      iconBgColor: AppColors.neutral50,
      iconBgDarkColor: AppColors.neutral700.withAlpha(100),
      actionType: ActionType.launchUrl,
      path: "mailto:subhampatel8092@gmail.com",
    ),
    SettingsContentModel(
      id: "app_version",
      title: "App Version",
      icon: AppSvgs.info,
      iconColor: AppColors.neutral500,
      iconBgColor: AppColors.neutral50,
      iconBgDarkColor: AppColors.neutral700.withAlpha(100),
      actionType: ActionType.none,
      actionText: "1.0.0",
    ),
  ];
}