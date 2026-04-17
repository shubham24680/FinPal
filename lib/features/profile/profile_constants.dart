import 'package:finpal/app/app.dart';

class ProfileConstants {
  static List<HelperModel> contentList = [
    HelperModel(
      icon: AppSvgs.addPayment,
      title: "Add Income/Expense",
      screenPath: "/add_amount",
    ),
    HelperModel(
      icon: AppSvgs.income,
      title: "Income Categories",
      screenPath: "/options",
      extra: ExtraModel(
        type: OnboardingConstants.incomeCategory,
        title: "Income Categories",
      ),
    ),
    HelperModel(
      icon: AppSvgs.expense,
      title: "Expense Categories",
      screenPath: "/options",
      extra: ExtraModel(
        type: OnboardingConstants.expenseCategory,
        title: "Expense Categories",
      ),
    ),
    HelperModel(
      icon: AppSvgs.upi,
      title: "Payment Methods",
      screenPath: "/options",
      extra: ExtraModel(
        type: OnboardingConstants.paymentMethod,
        title: "Payment Methods",
      ),
    ),
    HelperModel(
      icon: AppSvgs.upi,
      title: "Term and Conditions",
      pathType: PathType.urlPath,
      screenPath: "https://www.google.com/terms",
    ),
    HelperModel(
      icon: AppSvgs.upi,
      title: "Privacy Policy",
      pathType: PathType.urlPath,
      screenPath: "https://www.google.com/privacy",
    ),
  ];
}
