import 'package:finpal/features/settings/data/constants/option_constants.dart';
import 'package:finpal/features/settings/data/models/option_model.dart';
import 'package:finpal/features/settings/data/models/profile_model.dart';
import 'package:finpal/features/settings/data/models/settings_model.dart';
import 'package:finpal/features/transaction/data/models/payment_model.dart';
import 'package:finpal/features/transaction/data/transaction_constants.dart';

OptionModel makeOption({
  String? id,
  String? type,
  String name = 'Food',
  String icon = '',
  String color = 'primary',
}) =>
    OptionModel(
      id: id ?? 'opt_$name'.toLowerCase().replaceAll(' ', '_'),
      type: type ?? OptionType.expense.id,
      name: name,
      icon: icon,
      color: color,
    );

List<OptionModel> sampleExpenseCategories() => [
      makeOption(id: 'cat_food', name: 'Food'),
      makeOption(id: 'cat_travel', name: 'Travel'),
      makeOption(id: 'cat_rent', name: 'Rent'),
    ];

List<OptionModel> samplePaymentMethods() => [
      makeOption(
        id: 'method_cash',
        type: OptionType.paymentMethod.id,
        name: 'Cash',
      ),
      makeOption(
        id: 'method_upi',
        type: OptionType.paymentMethod.id,
        name: 'UPI',
      ),
    ];

List<OptionModel> sampleIncomeCategories() => [
      makeOption(
        id: 'cat_salary',
        type: OptionType.income.id,
        name: 'Salary',
      ),
    ];

PaymentModel makePayment({
  required String id,
  String? type,
  double amount = 100,
  DateTime? date,
  String categoryId = 'cat_food',
  String paymentMethodId = 'method_cash',
  String notes = '',
  String receiptPath = '',
  DateTime? createdAt,
}) {
  final when = date ?? DateTime(2026, 3, 15, 10);
  return PaymentModel(
    id: id,
    paymentType: type ?? TransactionType.expense.id,
    amount: amount,
    date: when,
    categoryId: categoryId,
    paymentMethodId: paymentMethodId,
    notes: notes,
    receiptPath: receiptPath,
    createdAt: createdAt ?? when,
    updatedAt: when,
  );
}

SettingsModel makeSettings({
  bool isFirstVisit = false,
  String currencyCode = 'INR',
  String themeMode = 'system',
  bool hideBalanceOnHome = false,
  bool dailyReminderEnabled = false,
  DateTime? dailyReminderTime,
  double monthlyBudget = 0,
}) =>
    SettingsModel(
      isFirstVisit: isFirstVisit,
      currencyCode: currencyCode,
      currencySymbol: currencyCode == 'USD' ? r'$' : '₹',
      languageCode: currencyCode == 'USD' ? 'en_US' : 'en_IN',
      themeMode: themeMode,
      hideBalanceOnHome: hideBalanceOnHome,
      dailyReminderEnabled: dailyReminderEnabled,
      dailyReminderTime: dailyReminderTime,
      monthlyBudget: monthlyBudget,
    );

ProfileModel makeProfile({
  String name = '',
  String dob = '',
  String gender = '',
  String profileImage = '',
  double? monthlyIncome,
}) =>
    ProfileModel(
      name: name,
      dob: dob,
      gender: gender,
      profileImage: profileImage,
      monthlyIncome: monthlyIncome,
    );
