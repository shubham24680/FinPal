import 'package:finpal/app/app.dart';

class CategoriesCard extends ConsumerWidget {
  const CategoriesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLandscape = context.isLandscape;
    final payments = ref.watch(transactionProvider).value?.payments ?? [];
    final allCategories = ref.watch(optionNotifer).value?.categories ?? [];
    final categories = AnalysisCalculator.getCategories(
      payments,
      allCategories,
      month: DateTime.now(),
    );
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
              text: "Top spending",
              fontType: FontType.body2Semibold,
              color: context.colors.onSurface,
            ),
            CustomTypography(
              text: "View All",
              fontType: FontType.label1Medium,
              color: context.colors.primary,
              decoration: TextDecoration.underline,
            ).onTap(event: () => openCategoriesList(ref, context)),
          ],
        ).padding(horizontal: 4.spMin),
        GridView.builder(
          itemCount: categories.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isLandscape ? 4 : 2,
            crossAxisSpacing: 12.spMin,
            mainAxisSpacing: 12.spMin,
          ),
          itemBuilder:
              (context, index) =>
                  _buildCategoryTile(context, ref, categories[index]),
        ),
      ],
    ).padding(
      horizontal: AppConstants.sidePadding,
      top: AppConstants.sidePadding,
    );
  }

  Widget _buildCategoryTile(
    BuildContext context,
    WidgetRef ref,
    AnalysisModel category,
  ) {
    final isDark = context.isDarkMode;
    final color = category.color;
    final amount = ref.formatCurrency(category.amount);

    return CustomContainer(
      backgroundColor: AppColors.transparent,
      padding: EdgeInsets.zero,
      onTap: () {
        ref.read(categoriesMonthProvider.notifier).state = DateTime.now();
        openCategoryDetail(ref, context, category.id);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.normal.withValues(alpha: isDark ? 0.35 : 0.1),
                  (isDark ? color.dimDark : color.extraLight)
                      .withValues(alpha: isDark ? 0.2 : 0.5),
                ],
              ).createShader(bounds),
              child: const CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: AppSvgs.folder,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.spMin,
            children: [
              CustomContainer(
                padding: EdgeInsets.all(12.r),
                backgroundColor: isDark ? color.dimDark : color.light,
                child: CustomImage(
                  imageType: ImageType.svgLocal,
                  imageUrl: category.icon,
                  color: color.normal,
                  height: 20.spMin,
                  width: 20.spMin,
                ),
              ),
              const Spacer(),
              CustomTypography(
                text: category.title,
                fontType: FontType.body2Semibold,
              ),
              CustomTypography(text: amount, fontType: FontType.body2Bold),
            ],
          ).padding(all: AppConstants.sidePadding),
        ],
      ),
    );
  }
}
