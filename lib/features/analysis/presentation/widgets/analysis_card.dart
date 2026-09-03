import 'package:finpal/app/app.dart';

class AnalysisCard extends ConsumerWidget {
  const AnalysisCard(
    this.analysis, {
    super.key,
    this.title = '',
    this.onTap,
    this.hideBalance = true,
  });

  final List<AnalysisModel> analysis;
  final String title;
  final VoidCallback? onTap;
  final bool hideBalance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLandscape = context.isLandscape;

    return CustomContainer(
      onTap: onTap,
      margin: EdgeInsets.symmetric(horizontal: AppConstants.sidePadding),
      showShadow: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            CustomTypography(text: title, fontType: FontType.body2Semibold),
            SizedBox(height: 16.spMin),
          ],
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  width: 50.spMin,
                  height: 50.spMin,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomImage(
                        imageType: ImageType.svgLocal,
                        imageUrl: AppSvgs.wallet,
                      ),
                      FinancePieChart(analysis),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 24.spMin),
              Expanded(
                flex: 2,
                child: GridView.builder(
                  itemCount: analysis.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isLandscape ? 3 : 2,
                    childAspectRatio: 1.8,
                    crossAxisSpacing: 8.spMin,
                  ),
                  itemBuilder:
                      (context, index) => _buildAnalysisTile(
                        context,
                        ref,
                        analysis[index],
                        hideBalance,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTile(
    BuildContext context,
    WidgetRef ref,
    AnalysisModel item,
    bool hideBalance,
  ) {
    final amountText = ref.formatCurrency(item.amount);
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8.w,
      children: [
        CustomContainer(
          height: 8.w,
          width: 8.w,
          backgroundColor: item.color.normal,
          borderRadius: BorderRadius.circular(1000.r),
        ),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.w,
            children: [
              CustomTypography(
                text: item.title,
                fontType: FontType.label1SemiBold,
              ),
              hideBalance
                  ? CustomTypography(
                    text: amountText,
                    fontType: FontType.label1Regular,
                    overflow: TextOverflow.ellipsis,
                  )
                  : Row(
                    spacing: 4.spMin,
                    children: List.generate(
                      4,
                      (index) => CustomContainer(
                        padding: EdgeInsets.all(4.spMin),
                        borderRadius: BorderRadius.circular(1000.r),
                        backgroundColor: context.colors.inverseSurface,
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class FinancePieChart extends StatelessWidget {
  final List<AnalysisModel> analysis;
  final double radius = 10;

  const FinancePieChart(this.analysis, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final allZero = analysis.every((element) => element.amount <= 0);

    return PieChart(
      swapAnimationDuration: const Duration(milliseconds: 400),
      PieChartData(
        centerSpaceRadius: 45,
        sectionsSpace: 0,
        sections:
            allZero
                ? [
                  PieChartSectionData(
                    value: 100,
                    color:
                        isDark ? ColorSet.primary.dark : ColorSet.primary.light,
                    radius: radius,
                    showTitle: false,
                  ),
                ]
                : analysis.map((element) {
                  final amount =
                      element.amount < 0 ? element.amount * -1 : element.amount;
                  return PieChartSectionData(
                    value: amount,
                    color: element.color.normal,
                    gradient: LinearGradient(
                      colors: [element.color.normal, element.color.extraLight],
                    ),
                    radius: radius,
                    showTitle: false,
                  );
                }).toList(),
      ),
    );
  }
}
