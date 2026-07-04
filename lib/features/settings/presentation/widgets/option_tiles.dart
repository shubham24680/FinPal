import 'package:finpal/app/app.dart';

class OptionTiles extends ConsumerWidget {
  final List<OptionModel> contents;
  final String? title;

  const OptionTiles(this.contents, {super.key, this.title});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionProvider = ref.watch(optionNotifer.notifier);
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
                  final colorSet = contents[index].color.colorSet;

                  return Row(
                    spacing: 12.spMin,
                    children: [
                      CustomContainer(
                        padding: EdgeInsets.all(12.r),
                        backgroundColor:
                            isDark ? colorSet.dimDark : colorSet.light,
                        child: CustomImage(
                          imageType: ImageType.svgLocal,
                          imageUrl: contents[index].icon,
                          color: colorSet.normal,
                          height: 16.spMin,
                          width: 16.spMin,
                        ),
                      ),
                      Expanded(
                        child: CustomTypography(
                          text: contents[index].name,
                          fontType: FontType.body2Medium,
                        ),
                      ),
                      CustomImage(
                        imageType: ImageType.svgLocal,
                        imageUrl: AppSvgs.edit,
                        color: context.colors.onSurface,
                        height: 20.spMin,
                        width: 20.spMin,
                        onClick:
                            () {
                              ref.read(selectedOptionProvider.notifier).state = contents[index];
                              context.push(AppRoutesPath.editOption.path);
                            },
                      ),
                      CustomImage(
                        imageType: ImageType.svgLocal,
                        imageUrl: AppSvgs.bin,
                        color: context.colors.error,
                        height: 20.spMin,
                        width: 20.spMin,
                        onClick:
                            () => CustomDialog.show(
                              context,
                              icon: AppSvgs.bin,
                              iconColor: AppColors.error500,
                              iconBgColor: AppColors.error50,
                              title: "Delete ${contents[index].name}",
                              message:
                                  "You can't undo this. Existing records keep their data.",
                              buttonText: "Yes, Delete",
                              buttonColor: AppColors.error500,
                              onPressed:
                                  () {
                                    optionProvider.deleteOption(contents[index].id);
                                    context.showSnackBar("Option deleted successfully");
                                    context.pop();
                                  },
                            ),
                      ),
                    ],
                  ).padding(horizontal: 16.r, vertical: 12.r);
                },
                separatorBuilder: (_, index) => Divider(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
