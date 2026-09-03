import 'package:finpal/app/app.dart';

class AnalysisCategoryBreakdown extends ConsumerWidget {
  const AnalysisCategoryBreakdown(
    this.analysis, {
    super.key,
    this.hideBalance = false,
  });

  final PeriodAnalysis analysis;
  final bool hideBalance;

  static const _topN = 6;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = analysis.categories;
    if (categories.isEmpty) return const SizedBox.shrink();

    final visible = categories.take(_topN).toList();

    return CustomContainer(
      showShadow: true,
      margin: EdgeInsets.symmetric(horizontal: AppConstants.sidePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.spMin,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTypography(
                text: 'Categories',
                fontType: FontType.body2Semibold,
              ),
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: AppSvgs.arrowRight,
                color: context.colors.onSurface,
              ).onTap(event: () => openCategoriesList(context)),
            ],
          ),
          ...visible.map((row) => _buildCategoryRow(context, ref, row)),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(
    BuildContext context,
    WidgetRef ref,
    AnalysisModel category,
  ) {
    final icon = category.icon ?? AppSvgs.bin;
    final color = category.color;
    final amount = ref.formatCurrency(category.amount);
    final percentage = '${category.percentage.toStringAsFixed(0)}%';

    return CustomContainer(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      onTap: () => openCategoryDetail(ref, context, category.id),
      child: Row(
        spacing: 12.w,
        children: [
          CustomContainer(
            height: 36.w,
            width: 36.w,
            padding: EdgeInsets.all(8.w),
            backgroundColor: context.isDarkMode ? color.dimDark : color.light,
            child:
                icon.isEmpty
                    ? null
                    : CustomImage(
                      imageType: ImageType.svgLocal,
                      imageUrl: icon,
                      color: color.normal,
                    ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2.w,
              children: [
                CustomTypography(
                  text: category.title,
                  fontType: FontType.label1Medium,
                ),
                CustomTypography(
                  text:
                      '${category.count} items ${UnicodeConstants.dot} $percentage',
                  fontType: FontType.label2Regular,
                  color: context.colors.onSurface,
                ),
              ],
            ),
          ),
          CustomTypography(text: amount, fontType: FontType.label1SemiBold),
        ],
      ),
    );
  }
}
