import 'package:finpal/app/app.dart';
import 'package:finpal/core/theme/app_colors.dart';

enum OnboardingContent {
  onboarding(
    data: OnboardingModel(
      image: AppImages.onboarding1,
      title: [
        OnboardingTypographyModel(text: "Track "),
        OnboardingTypographyModel(
          text: "Expenses.",
          color: AppColors.primary500,
        ),
        OnboardingTypographyModel(text: "\nBuild Better "),
        OnboardingTypographyModel(text: "Habits.", color: AppColors.primary500),
      ],
      subtitle: OnboardingTypographyModel(
        text: "Monitor your spending and make smarter financial decisions.",
      ),
      button: OnboardingButtonModel(
        label: "Let's Get Started!",
        suffixIcon: AppSvgs.arrowRight,
      ),
    ),
  ),
  personalDetails(
    data: OnboardingModel(
      image: AppImages.onboarding2,
      title: [
        OnboardingTypographyModel(text: "Tell us a little about"),
        OnboardingTypographyModel(
          text: "\n yourself.",
          color: AppColors.primary500,
        ),
      ],
      subtitle: OnboardingTypographyModel(
        text:
            "This will help us personalize your experience.\n All data stays on your device.",
      ),
      button: OnboardingButtonModel(label: "Continue"),
    ),
  ),
  security(
    data: OnboardingModel(
      image: AppImages.onboarding3,
      title: [OnboardingTypographyModel(text: "Protect your data")],
      subtitle: OnboardingTypographyModel(
        text: "Local lock, No Server. You can control it.",
      ),
      button: OnboardingButtonModel(label: "Enable passcode & finish"),
    ),
  );

  const OnboardingContent({required this.data});
  final OnboardingModel data;
}

class OnboardingConstants {
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
