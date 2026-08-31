import 'package:finpal/app/app.dart';

class OptionsBottomSheet extends StatefulWidget {
  const OptionsBottomSheet(
    this.categories, {
    super.key,
    this.title,
    this.selectedOption,
  });

  final List<OptionModel> categories;
  final OptionModel? selectedOption;
  final String? title;

  @override
  State<OptionsBottomSheet> createState() => _OptionsBottomSheetState();
}

class _OptionsBottomSheetState extends State<OptionsBottomSheet> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<OptionModel> get filteredOptions {
    final searchedText = controller.text.trim();
    if (searchedText.isEmpty) {
      return widget.categories;
    }

    return widget.categories
        .where(
          (option) =>
              option.name.toLowerCase().contains(searchedText.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final values = filteredOptions;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 12.spMin),
        CustomTextField(
          controller: controller,
          hintText: "Search",
          onChanged: (_) => setState(() {}),
          perfixIcon: CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: AppSvgs.search,
            color: context.colors.outline,
          ),
        ),
        values.isEmpty
            ? buildNoCategories(context)
            : Expanded(
              child: ListView.separated(
                itemCount: values.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder:
                    (context, index) => optionTile(context, values[index]),
                separatorBuilder: (_, _) => const Divider(),
              ),
            ),
      ],
    ).onTap(event: () => context.focusNode.unfocus());
  }

  Widget optionTile(BuildContext context, OptionModel option) {
    final color = option.color.colorSet;
    final isSelected = option.id == widget.selectedOption?.id;

    return CustomContainer(
      onTap: () => context.pop(option),
      padding: EdgeInsets.symmetric(vertical: 16.r),
      child: Row(
        spacing: 12.spMin,
        children: [
          CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: option.icon,
            color: color.normal,
          ),
          Expanded(child: CustomTypography(text: option.name, fontType: FontType.body2Medium)),
          if (isSelected)
            CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: AppSvgs.checkSquare,
              color: color.normal,
            ),
        ],
      ),
    );
  }

  Widget buildNoCategories(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImage(
              imageUrl: AppImages.noCategories,
            ).padding(horizontal: 72.spMin),
            CustomTypography(
              text: "No categories found",
              fontType: FontType.h4Semibold,
            ),
            SizedBox(height: 8.spMin),
            CustomTypography(
              text:
                  "We couldn't find a category that matches your search. Try a different name.",
              fontType: FontType.label1Medium,
              color: context.colors.onSurface,
              align: TextAlign.center,
            ),
            SizedBox(height: 16.spMin),
            CustomButton(
              label: "Add a category",
              prefixIcon: AppSvgs.add1,
              onTap: () {
                ref.read(selectedOptionProvider.notifier).state = null;
                context.push(AppRoutesPath.editOption.path);
              },
            ),
          ],
        ).padding(horizontal: AppConstants.sidePadding, vertical: 16.r);
      },
    );
  }
}
