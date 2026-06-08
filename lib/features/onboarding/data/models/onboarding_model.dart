import 'package:finpal/app/app.dart';

class OnboardingModel {
  final String image;
  final List<OnboardingTypographyModel> title;
  final OnboardingTypographyModel? subtitle;
  final OnboardingButtonModel button;

  const OnboardingModel({
    required this.image,
    this.title = const [],
    this.subtitle,
    required this.button,
  });
}

class OnboardingTypographyModel {
  final String text;
  final FontType? fontType;
  final Color? color;
  final FontStyle? fontStyle;

  const OnboardingTypographyModel({
    required this.text,
    this.fontType,
    this.color,
    this.fontStyle,
  });
}

class OnboardingButtonModel {
  final String label;
  final String? prefixIcon;
  final String? suffixIcon;

  const OnboardingButtonModel({
    required this.label,
    this.prefixIcon,
    this.suffixIcon,
  });
}
