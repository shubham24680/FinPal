import 'package:finpal/app/app.dart';

class ProfileConstants {
  static List<HelperModel> contentList = [
    // HelperModel(
    //   icon: AppSvgs.addPayment,
    //   title: "Add Income/Expense",
    //   screenPath: "/add_amount",
    // ),
    HelperModel(
      icon: AppSvgs.income,
      title: "Income Categories",
      screenPath: "/options",
      extra: ExtraModel(
        type: OnboardingConstants.incomeCategory,
        title: "Income Categories",
        icon: AppSvgs.income,
      ),
    ),
    HelperModel(
      icon: AppSvgs.expense,
      title: "Expense Categories",
      screenPath: "/options",
      extra: ExtraModel(
        type: OnboardingConstants.expenseCategory,
        title: "Expense Categories",
        icon: AppSvgs.expense,
      ),
    ),
    HelperModel(
      icon: AppSvgs.upi,
      title: "Payment Methods",
      screenPath: "/options",
      extra: ExtraModel(
        type: OnboardingConstants.paymentMethod,
        title: "Payment Methods",
        icon: AppSvgs.upi,
      ),
    ),
    HelperModel(
      icon: AppSvgs.toc,
      title: "Term and Conditions",
      pathType: PathType.urlPath,
      screenPath: "https://www.google.com/terms",
    ),
    HelperModel(
      icon: AppSvgs.privacy,
      title: "Privacy Policy",
      pathType: PathType.urlPath,
      screenPath: "https://www.google.com/privacy",
    ),
  ];
}
