import 'package:finpal/app/app.dart';

Widget settingsTiles(
  BuildContext context,
  List<SettingsContentModel> settingsContents, {
  String? title,
}) {
  final contents = settingsContents.toList();

  if (contents.isEmpty) {
    return const SizedBox.shrink();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != null)
        CustomTypography(
          text: title,
          fontType: FontType.body2Medium,
          color: context.colors.onSurface,
        ).padding(left: 8.r, bottom: 4.r),
      CustomContainer(
        backgroundColor: context.colors.surface,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            ListView.separated(
              itemCount: contents.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (_, index) {
                return _settingsTile(context, contents[index]);
              },
              separatorBuilder:
                  (_, index) =>
                      Divider(color: context.colors.outline, height: 0),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _settingsTile(BuildContext context, SettingsContentModel contents) {
  final isDark = context.isDarkMode;
  final iconDarkColor = contents.iconBgDarkColor ?? contents.iconBgColor;

  return CustomContainer(
    onTap: () => _handleTap(context, contents),
    padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
    child: Row(
      spacing: 12.spMin,
      children: [
        CustomContainer(
          padding: EdgeInsets.all(12.r),
          backgroundColor: isDark ? iconDarkColor : contents.iconBgColor,
          child: CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: contents.icon,
            color: contents.iconColor,
            height: 16.spMin,
            width: 16.spMin,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.spMin,
            children: [
              CustomTypography(
            text: contents.title,
            fontType: FontType.body2Medium,
            maxLines: 1,
          ),
          if (contents.subtitle.isNotEmpty)
              CustomTypography(
            text: contents.subtitle,
            fontType: FontType.label1Regular,
            color: context.colors.onSurfaceVariant,
            maxLines: 1,
          ),
            ],
          )
        ),
        if (contents.actionText.isNotEmpty)
          CustomTypography(
            text: contents.actionText,
            fontType: FontType.body2Medium,
            color: context.colors.onSurface,
          ),
        CustomImage(
          imageType: ImageType.svgLocal,
          imageUrl: AppSvgs.arrowRight1,
          color: context.colors.onSurfaceVariant,
          height: 16.spMin,
        ),
      ],
    ),
  );
}

void _handleTap(BuildContext context, SettingsContentModel contents) {
  switch (contents.actionType) {
    case ActionType.navigate:
      contents.path.isNotEmpty ? context.push(contents.path) : null;
      break;
    case ActionType.launchUrl:
      contents.path.isNotEmpty ? launchUrl(Uri.parse(contents.path)) : null;
      break;
    case ActionType.toggle:
      break;
    case ActionType.bottomSheet:
      break;
  }
}
