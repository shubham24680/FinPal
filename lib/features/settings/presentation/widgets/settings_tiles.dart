import 'package:finpal/app/app.dart';

class SettingsTiles extends ConsumerWidget {
  const SettingsTiles({super.key, required this.contents, this.title});

  final List<SettingsContentModel> contents;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = handleContents(ref, contents);
    if (items.isEmpty) {
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
                itemCount: items.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (_, index) {
                  return _settingsTile(context, items[index]);
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

  Widget _settingsTile(BuildContext context, SettingsContentModel items) {
    final isDark = context.isDarkMode;
    final iconDarkColor = items.iconBgDarkColor ?? items.iconBgColor;

    return CustomContainer(
      onTap: () => _handleTap(context, items),
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
      child: Row(
        spacing: 12.spMin,
        children: [
          CustomContainer(
            padding: EdgeInsets.all(12.r),
            backgroundColor: isDark ? iconDarkColor : items.iconBgColor,
            child: CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: items.icon,
              color: items.iconColor,
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
                  text: items.title,
                  fontType: FontType.body2Medium,
                  maxLines: 1,
                ),
                if (items.subtitle.isNotEmpty)
                  CustomTypography(
                    text: items.subtitle,
                    fontType: FontType.label1Regular,
                    color: context.colors.onSurfaceVariant,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          if (items.actionText.isNotEmpty)
            CustomTypography(
              text: items.actionText,
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

  List<SettingsContentModel> handleContents(WidgetRef ref, List<SettingsContentModel> contents) {
    return contents.map((e) {
      if(e.id == "theme") {
        final themeMode = ref.watch(themeProvider);
        return e.copyWith(actionText: themeMode.name);
      }
      if(e.id == "currency") {
        final currency = ref.watch(currencyProvider);
        return e.copyWith(actionText: currency.currency);
      }
      
      return e;
    }).toList();
  }
}
