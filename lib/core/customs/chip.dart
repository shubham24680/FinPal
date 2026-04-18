import 'package:finpal/app/app.dart';

enum TagType { FILLED, OUTLINED }

enum TagSize { LARGE, MEDIUM, SMALL }

class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    this.tagType = TagType.FILLED,
    this.tagSize = TagSize.MEDIUM,
    this.icon,
    this.value,
    this.color,
    this.backgroundColor,
  });

  final TagType tagType;
  final TagSize tagSize;
  final String? icon;
  final String? value;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final height = _getHeight();

    final outlined = tagType == TagType.OUTLINED;
    final borderRadius = BorderRadius.circular(1.2 * height);
    final decoration = BoxDecoration(
      color:
          outlined
              ? Colors.transparent
              : backgroundColor ?? PrimaryColors.shade100,
      borderRadius: borderRadius,
      border: Border.all(color: backgroundColor ?? PrimaryColors.shade100),
    );
    final image = CustomImage(
      imageType: ImageType.svgLocal,
      imageUrl: icon,
      height: height,
      color: color ?? PrimaryColors.shade500,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 0.6 * height,
        vertical: 0.2 * height,
      ),
      decoration: decoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) image,
          if (icon != null && value != null) const SizedBox(width: 5),
          if (value != null)
            CustomTypography(
              text: value,
              fontType: FontType.label2Regular,
              color: color ?? PrimaryColors.shade500,
            ),
        ],
      ),
    );
  }

  double _getHeight() {
    return switch (tagSize) {
      TagSize.LARGE => 16.w,
      TagSize.SMALL => 8.w,
      _ => 12.w,
    };
  }
}
