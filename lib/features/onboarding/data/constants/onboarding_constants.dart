import 'package:finpal/app/app.dart';

enum OnboardingContent {
  intro(screen: IntroScreen()),
  personalDetails(screen: PersonalDetailsScreen());
  // security(screen: LockScreen());

  const OnboardingContent({required this.screen});
  final Widget screen;
}
