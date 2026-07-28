import 'package:finpal/app/app.dart';

class CategoriesCard extends ConsumerWidget {
  const CategoriesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final categories = ref.watch(optionNotifer).value?.expenseCategories ?? [];
    final categories = [
      AnalysisModel(
        id: "food_and_drinks",
        title: "Food & Drinks",
        amount: 1048,
        color: ColorSet.purple,
        icon: AppSvgs.food,
      ),
      AnalysisModel(
        id: "transportation",
        title: "Transportation",
        amount: 1040,
        color: ColorSet.accent,
        icon: AppSvgs.transportation,
      ),
      AnalysisModel(
        id: "entertainment",
        title: "Entertainment",
        amount: 483,
        color: ColorSet.neutral,
        icon: AppSvgs.entertainment,
      ),
      AnalysisModel(
        id: "shopping",
        title: "Shopping",
        amount: 1820,
        color: ColorSet.info,
        icon: AppSvgs.shopping,
      ),
    ];
    if (categories.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.spMin,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 8.spMin,
          children: [
            CustomTypography(
              text: "Categories",
              fontType: FontType.body2Semibold,
              color: context.colors.onSurface,
            ),
            CustomTypography(
              text: "View All",
              fontType: FontType.label1Medium,
              color: context.colors.primary,
              decoration: TextDecoration.underline,
            ).onTap(event: () {}),
          ],
        ).padding(horizontal: 4.spMin),
        GridView.builder(
          itemCount: categories.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.spMin,
            mainAxisSpacing: 12.spMin,
          ),
          itemBuilder:
              (context, index) =>
                  _buildCategoryTile(context, categories[index]),
        ),
      ],
    ).padding(
      horizontal: AppConstants.sidePadding,
      top: AppConstants.sidePadding,
    );
  }

  Widget _buildCategoryTile(BuildContext context, AnalysisModel category) {
    final isDark = context.isDarkMode;
    final color = category.color;
    final amount = CurrencyFormatter.format(category.amount);

    return CustomContainer(
      gradient: RadialGradient(
        center: Alignment.bottomRight,
        colors: [color.normal, isDark ? color.dimDark : color.light],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.spMin,
        children: [
          CustomContainer(
            padding: EdgeInsets.all(12.r),
            backgroundColor: isDark ? color.dimDark : color.extraLight,
            child: CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: category.icon,
              color: color.normal,
              height: 20.spMin,
              width: 20.spMin,
            ),
          ),
          Spacer(),
          CustomTypography(
            text: category.title,
            fontType: FontType.body2Semibold,
          ),
          CustomTypography(text: amount, fontType: FontType.body2Bold),
        ],
      ),
    );
  }
}
