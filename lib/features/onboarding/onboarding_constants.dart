import 'package:finpal/app/app.dart';

class OnboardingConstants {
  static final onboardingPadding = 24.w;
  static final List<OnboardingModel> onboardingData = [
    OnboardingModel(
      image: 'assets/images/onboarding_1.webp',
      title: ["Send ", "and ", "receive", "\npayment", "\ninstantly"],
      subtitle:
          'Make payments to any of your contacts super easily and fast. Zero fees, no matter the amount.',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding_2.webp',
      title: ["Grow your\nsavings", " account with", " vaults"],
      subtitle:
          'Set a financial goal and achieve it with your vault. No fund locking or any other commitment.',
    ),
  ];

  static const income = 'income';
  static const expense = 'expense';
  static const paymentMethod = 'payment_method';
  static const incomeCategory = 'income_category';
  static const expenseCategory = 'expense_category';

  static final List<OptionModel> paymentMethods = [
    OptionModel(
      id: paymentMethod,
      type: paymentMethod,
      name: "Other",
      icon: AppSvgs.add,
    ),
    OptionModel(type: paymentMethod, name: "UPI", icon: AppSvgs.upi),
    OptionModel(
      type: paymentMethod,
      name: "Net Banking",
      icon: AppSvgs.netBanking,
    ),
    OptionModel(type: paymentMethod, name: "Credit Card", icon: AppSvgs.card),
    OptionModel(type: paymentMethod, name: "Debit Card", icon: AppSvgs.card),
    OptionModel(type: paymentMethod, name: "Cash", icon: AppSvgs.cash),
    OptionModel(type: paymentMethod, name: "Wallet", icon: AppSvgs.wallet),
  ];

  static final List<OptionModel> incomeCategories = [
    OptionModel(
      id: incomeCategory,
      type: incomeCategory,
      name: "Other",
      icon: AppSvgs.add,
    ),
    OptionModel(type: incomeCategory, name: "Salary", icon: AppSvgs.salary),
    OptionModel(
      type: incomeCategory,
      name: "Freelance",
      icon: AppSvgs.wadOfMoney,
    ),
    OptionModel(type: incomeCategory, name: "Investment", icon: AppSvgs.cash),
    OptionModel(type: incomeCategory, name: "Gift", icon: AppSvgs.gift),
  ];

  static final List<OptionModel> expenseCategories = [
    OptionModel(
      id: expenseCategory,
      type: expenseCategory,
      name: "Other",
      icon: AppSvgs.add,
    ),
    OptionModel(type: expenseCategory, name: "Food", icon: AppSvgs.food),
    OptionModel(type: expenseCategory, name: "Rent", icon: AppSvgs.rent),
    OptionModel(
      type: expenseCategory,
      name: "Shows",
      icon: AppSvgs.entertainment,
    ),
    OptionModel(type: expenseCategory, name: "Bills", icon: AppSvgs.bills),
  ];

  static final List<OptionModel> allOptions = [
    ...paymentMethods,
    ...incomeCategories,
    ...expenseCategories,
  ];
}
