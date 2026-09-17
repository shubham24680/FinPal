import 'package:finpal/app/app.dart';

Widget buildPageIndicator(
  BuildContext context,
  OnboardingState onboardingState,
) {
  return SmoothPageIndicator(
    controller: onboardingState.pageController,
    count: OnboardingContent.values.length,
    effect: ExpandingDotsEffect(
      activeDotColor: AppColors.primary500,
      dotColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      dotHeight: 8.spMin,
      dotWidth: 8.spMin,
      spacing: 6.spMin,
      expansionFactor: 2.5,
    ),
  );
}
