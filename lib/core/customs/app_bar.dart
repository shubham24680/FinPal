import 'package:finpal/app/app.dart';
import 'package:finpal/core/extensions/gesture_extenstion.dart';
import 'package:flutter/material.dart';

class AppBarModel {
  final String icon;
  final VoidCallback onTap;

  AppBarModel({required this.icon, required this.onTap});
}

AppBar customAppBar(
  BuildContext context, {
  String? title,
  bool enableBack = true,
  VoidCallback? onBack,
  List<AppBarModel> actions = const [],
  PreferredSizeWidget? bottom,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: BGColors.shade500,
    leading:
        enableBack
            ? CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: AppSvgs.arrowLeft,
            ).onTap(event: onBack ?? () => context.pop()).padding(all: 12.w)
            : null,
    title:
        title != null
            ? CustomTypography(text: title, fontType: FontType.body1Medium)
            : null,
    actions:
        actions
            .map(
              (e) => CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: e.icon,
                height: 24.w,
              ).onTap(event: e.onTap).padding(right: 16.w),
            )
            .toList(),
    bottom: bottom,
  );
}
