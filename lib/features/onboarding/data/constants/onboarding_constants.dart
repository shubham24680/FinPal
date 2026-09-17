import 'package:finpal/app/app.dart';

enum OnboardingContent {
  intro(screen: IntroScreen()),
  personalDetails(screen: PersonalDetailsScreen());

  const OnboardingContent({required this.screen});
  final Widget screen;
}
