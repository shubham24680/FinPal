import 'package:finpal/app/app.dart';

class AnalysisBreakdown extends ConsumerWidget {
  const AnalysisBreakdown(this.analysis, {super.key, this.hideBalance = false});

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
              ).onTap(event: () => context.push(AppRoutesPath.categories.path)),
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

class AnalysisBreakdown1 extends ConsumerWidget {
  const AnalysisBreakdown1(
    this.analysis, {
    super.key,
    this.hideBalance = false,
  });

  final PeriodAnalysis analysis;
  final bool hideBalance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = analysis.methods;
    if (methods.isEmpty) return const SizedBox.shrink();

    final currency = ref.watch(currencyProvider);

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
                text: 'Payment Methods',
                fontType: FontType.body2Semibold,
              ),
            ],
          ),
          ...methods.map(
            (row) => _buildMethodRow(context, row, currency, analysis.expense),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodRow(
    BuildContext context,
    AnalysisModel method,
    CurrencyContants currency,
    double maxAmount,
  ) {
    final icon = method.icon ?? AppSvgs.bin;
    final color = method.color;
    final percentage = '${method.percentage.toStringAsFixed(0)}%';
    final fraction = maxAmount > 0 ? method.amount / maxAmount : 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6.spMin,
      children: [
        Row(
          children: [
            if (icon.isNotEmpty) ...[
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: icon,
                height: 16.spMin,
                width: 16.spMin,
                color: color.normal,
              ),
              SizedBox(width: 8.spMin),
            ],
            Expanded(
              child: CustomTypography(
                text: method.title,
                fontType: FontType.label1Medium,
              ),
            ),
            CustomTypography(
              text: '${method.count} items ${UnicodeConstants.dot} $percentage',
              fontType: FontType.label2Regular,
              color: context.colors.onSurface,
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: fraction.clamp(0.0, 1.0) as double?,
            minHeight: 6.spMin,
            backgroundColor: context.colors.surfaceContainerHighest,
            color: color.normal,
            borderRadius: BorderRadius.circular(6.r),
          ),
        ),
      ],
    );
  }
}
