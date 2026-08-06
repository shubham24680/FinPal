import 'package:finpal/app/app.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 0)
class SettingsModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1, defaultValue: true)
  final bool isFirstVisit;
  @HiveField(2, defaultValue: false)
  final bool isFingerprintEnabled;
  @HiveField(3, defaultValue: false)
  final bool isPasscodeEnabled;
  @HiveField(4, defaultValue: 'INR')
  final String currencyCode;
  @HiveField(5, defaultValue: '₹')
  final String currencySymbol;
  @HiveField(6, defaultValue: 'en')
  final String languageCode;
  @HiveField(7, defaultValue: 'system')
  final String themeMode;
  @HiveField(8, defaultValue: false)
  final bool hideBalanceOnHome;
  @HiveField(9, defaultValue: false)
  final bool dailyReminderEnabled;
  @HiveField(10)
  final DateTime? dailyReminderTime;
  @HiveField(11)
  final double? monthlyBudget;
  @HiveField(12, defaultValue: false)
  final bool aiInsightsEnabled;

  SettingsModel({
    String? id,
    this.isFirstVisit = true,
    this.isFingerprintEnabled = false,
    this.isPasscodeEnabled = false,
    this.currencyCode = 'INR',
    this.currencySymbol = '₹',
    this.languageCode = 'en',
    this.themeMode = 'system',
    this.hideBalanceOnHome = false,
    this.dailyReminderEnabled = false,
    this.dailyReminderTime,
    this.monthlyBudget,
    this.aiInsightsEnabled = false,
  })  : id = id ?? Uuid().v4();

  SettingsModel copyWith({
    bool? isFirstVisit,
    bool? isFingerprintEnabled,
    bool? isPasscodeEnabled,
    String? currencyCode,
    String? currencySymbol,
    String? languageCode,
    String? themeMode,
    bool? hideBalanceOnHome,
    bool? dailyReminderEnabled,
    DateTime? dailyReminderTime,
    double? monthlyBudget,
    bool? aiInsightsEnabled,
  }) => SettingsModel(
        id: id,
        isFirstVisit: isFirstVisit ?? this.isFirstVisit,
        isFingerprintEnabled:
            isFingerprintEnabled ?? this.isFingerprintEnabled,
        isPasscodeEnabled: isPasscodeEnabled ?? this.isPasscodeEnabled,
        currencyCode: currencyCode ?? this.currencyCode,
        currencySymbol: currencySymbol ?? this.currencySymbol,
        languageCode: languageCode ?? this.languageCode,
        themeMode: themeMode ?? this.themeMode,
        hideBalanceOnHome: hideBalanceOnHome ?? this.hideBalanceOnHome,
        dailyReminderEnabled:
            dailyReminderEnabled ?? this.dailyReminderEnabled,
        dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
        monthlyBudget: monthlyBudget ?? this.monthlyBudget,
        aiInsightsEnabled: aiInsightsEnabled ?? this.aiInsightsEnabled,
      );
}

enum ActionType {
  none,
  toggle,
  navigate,
  launchUrl,
  bottomSheet,
}

class SettingsContentModel {
  final String id;
  final String title;
  final String subtitle;
  final String actionText;
  final String icon;
  final Color iconColor;
  final Color iconBgColor;
  final Color? iconBgDarkColor;
  final ActionType actionType;
  final String path;
  final bool value;

  SettingsContentModel({
    required this.id,
    required this.title,
    this.subtitle = "",
    this.actionText = "",
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.iconBgDarkColor,
    this.actionType = ActionType.navigate,
    this.path = "",
    this.value = false,
  });

  SettingsContentModel copyWith({
    String? id,
    String? title,
    String? icon,
    Color? iconColor,
    Color? iconBgColor,
    ActionType? actionType,
    String? path,
    String? subtitle,
    String? actionText,
    Color? iconBgDarkColor,
    bool? value,
  }) => SettingsContentModel(
    id: id ?? this.id,
    title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle,
    actionText: actionText ?? this.actionText,
    icon: icon ?? this.icon,
    iconColor: iconColor ?? this.iconColor,
    iconBgColor: iconBgColor ?? this.iconBgColor,
    iconBgDarkColor: iconBgDarkColor ?? this.iconBgDarkColor,
    path: path ?? this.path,
    actionType: actionType ?? this.actionType,
    value: value ?? this.value,
  );
}