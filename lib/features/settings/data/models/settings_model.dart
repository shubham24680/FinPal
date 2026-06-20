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
