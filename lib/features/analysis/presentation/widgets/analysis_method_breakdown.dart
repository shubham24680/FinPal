import 'package:finpal/app/app.dart';

class AnalysisMethodBreakdown extends ConsumerWidget {
  const AnalysisMethodBreakdown(
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
                text: 'Payment methods',
                fontType: FontType.body2Semibold,
              ),
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: AppSvgs.arrowRight,
                color: context.colors.onSurface,
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
