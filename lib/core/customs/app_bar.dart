import 'package:finpal/app/app.dart';

class AppBarModel {
  final String icon;
  final VoidCallback onTap;

  AppBarModel({required this.icon, required this.onTap});
}

AppBar customAppBar(
  BuildContext context,
  String title, {
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
    title: CustomTypography(text: title, fontType: FontType.body1Medium),
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
