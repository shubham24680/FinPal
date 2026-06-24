import 'package:finpal/app/app.dart';

Widget viewContents(
    BuildContext context,
    List<ProfileContentModel> profileContents,
    Map<String, String> values, {
    String? title,
  }) {
    final contents =
        profileContents
            .where((e) => values[e.id]?.isNotEmpty ?? false)
            .map((e) => e.copyWith(value: values[e.id]))
            .toList();

    if (contents.isEmpty) {
      return const SizedBox.shrink();
    }

    final isDark = context.isDarkMode;
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
                  final iconDarkColor = contents[index].iconBgDarkColor ?? contents[index].iconBgColor;
                  return Row(
                    spacing: 12.spMin,
                    children: [
                      CustomContainer(
                        padding: EdgeInsets.all(12.r),
                        backgroundColor: isDark ? iconDarkColor : contents[index].iconBgColor,
                        child: CustomImage(
                          imageType: ImageType.svgLocal,
                          imageUrl: contents[index].icon,
                          color: contents[index].iconColor,
                          height: 16.spMin,
                          width: 16.spMin,
                        ),
                      ),
                      CustomTypography(
                        text: contents[index].title,
                        fontType: FontType.body2Medium,
                      ),
                      if (contents[index].value.isNotEmpty) ...[
                        const Spacer(),
                        CustomTypography(
                          text: contents[index].value,
                          fontType: FontType.body2Medium,
                          color: context.colors.onSurface,
                        ),
                      ],
                    ],
                  ).padding(horizontal: 16.r, vertical: 12.r);
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