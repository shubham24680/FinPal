import 'package:finpal/app/app.dart';

class AppBarModel {
  final String icon;
  final Color? color;
  final VoidCallback onTap;

  AppBarModel({required this.icon, this.color, required this.onTap});
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
    leading:
        enableBack
            ? CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: AppSvgs.arrowLeft,
              color: context.colors.inverseSurface,
            ).onTap(event: onBack ?? () => context.pop()).padding(all: 12.r)
            : null,
    title:
        title != null
            ? CustomTypography(text: title, fontType: FontType.h4Medium)
            : null,
    actions:
        actions
            .map(
              (e) => CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: e.icon,
                // height: 24.spMin,
                color: e.color,
              ).onTap(event: e.onTap).padding(right: 16.r),
            )
            .toList(),
    bottom: bottom,
  );
}
