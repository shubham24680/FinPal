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
