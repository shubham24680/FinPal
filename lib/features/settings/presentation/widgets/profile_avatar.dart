import 'dart:io';

import 'package:finpal/app/app.dart';

Widget buildAvatar(
  BuildContext context, {
  String image = "",
  String name = "",
  double? size,
  bool enableBorder = false,
  Color? borderColor,
}) {
  final initials = name
      .split(' ')
      .where((e) => e.isNotEmpty)
      .map((e) => e[0])
      .join('');

  final child =
      image.isNotEmpty
          ? ClipOval(child: Image.file(File(image), fit: BoxFit.cover, height: size ?? 60.spMin, width: size ?? 60.spMin))
          : initials.isNotEmpty
          ? CustomTypography(
            text: initials,
            fontType: FontType.h2Semibold,
            color: AppColors.primary500,
          )
          : CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: AppSvgs.user1,
            color: AppColors.primary500,
          );
  return CustomContainer(
    borderRadius: BorderRadius.circular(1000.r),
    height: size ?? 60.spMin,
    width: size ?? 60.spMin,
    padding: image.isNotEmpty ? EdgeInsets.zero :EdgeInsets.all(8.r),
    backgroundColor: AppColors.primary50,
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
