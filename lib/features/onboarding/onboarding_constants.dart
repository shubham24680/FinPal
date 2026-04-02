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
}
