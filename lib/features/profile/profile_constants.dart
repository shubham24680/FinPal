import 'package:finpal/app/app.dart';

class ProfileConstants {
  static List<HelperModel> contentList = [
    HelperModel(
      icon: AppSvgs.fingerprint,
      title: "Fingerprint Authentication",
      action: ProfileAction.toggle,
    ),
    HelperModel(
      icon: AppSvgs.privacy,
      title: "Change Passcode",
      screenPath: "/pin_auth",
    ),
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
      screenPath:
          "https://shubham24680.github.io/policy/finpal-terms-and-conditions.html",
    ),
    HelperModel(
      icon: AppSvgs.policy,
      title: "Privacy Policy",
      pathType: PathType.urlPath,
      screenPath:
          "https://shubham24680.github.io/policy/finpal-privacy-policy.html",
    ),
  ];
}
