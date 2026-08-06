import 'dart:io';

import 'package:finpal/app/app.dart';

Widget buildAvatar(
  BuildContext context, {
  String image = "",
  String name = "",
  String icon = AppSvgs.user1,
  ColorSet color = ColorSet.primary,
  double? size,
  bool enableBorder = false,
  Color? borderColor,
  VoidCallback? onTap,
  bool showShadow = false,
}) {
  final isDark = context.isDarkMode;
  final initials =
      name
          .split(' ')
          .where((e) => e.isNotEmpty)
          .map((e) => e[0])
          .join('')
          .toUpperCase();
  final fallback =
      initials.isNotEmpty
          ? CustomTypography(
            text: initials,
            fontType: FontType.h2Semibold,
            color: color.normal,
          )
          : CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: icon,
            color: color.normal,
          );

  final child =
      image.isNotEmpty
          ? ClipOval(
            child: Image.file(
              File(image),
              fit: BoxFit.cover,
              height: size ?? 60.spMin,
              width: size ?? 60.spMin,
              errorBuilder: (context, error, stackTrace) => fallback,
            ),
          )
          : fallback;
  return CustomContainer(
    onTap: onTap,
    showShadow: showShadow,
    borderRadius: BorderRadius.circular(1000.r),
    height: size ?? 60.spMin,
    width: size ?? 60.spMin,
    padding: image.isNotEmpty ? EdgeInsets.zero : EdgeInsets.all(8.r),
    backgroundColor: isDark ? color.dimDark : color.light,
    border:
        enableBorder
            ? Border.all(
              color: borderColor ?? context.colors.surface,
              width: 2.r,
            )
            : null,
    alignment: Alignment.center,
    child: child,
  );
}
