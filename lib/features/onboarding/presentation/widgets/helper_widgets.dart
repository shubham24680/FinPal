import 'package:finpal/app/app.dart';

Widget onboardingTypo(
  BuildContext context,
  List<OnboardingTypographyModel> typos,
) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      children:
          typos
              .map(
                (e) => TextSpan(
                  text: e.text,
                  style: CustomTypography(
                    text: e.text,
                    fontType: e.fontType ?? FontType.h2Medium,
                    color: e.color,
                    fontStyle: e.fontStyle,
                  ).getTextStyle(context),
                ),
              )
              .toList(),
    ),
  );
}

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
