import 'package:finpal/app/app.dart';

class AnalysisTrendChart extends ConsumerWidget {
  const AnalysisTrendChart(
    this.trend,
    this.period, {
    super.key,
    this.hideBalance = false,
    this.color = ColorSet.primary,
    this.title = "",
  });

  final List<AnalysisModel> trend;
  final AnalysisPeriod period;
  final bool hideBalance;
  final ColorSet color;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (trend.isEmpty) return const SizedBox.shrink();

    final range = period.range;
    final startDate = range.start.formatDate(type: DateFormatType.shortDate);
    final endDate = range.end.formatDate(type: DateFormatType.shortDate);
    final currency = ref.selectedCurrency;
    final maxY = trend.fold<double>(0, (m, p) => p.amount > m ? p.amount : m);
    final chartMax = maxY <= 0 ? 1.0 : maxY * 1.15;
    final labelStep = _labelStep(trend.length);

    return CustomContainer(
      margin: EdgeInsets.symmetric(horizontal: AppConstants.sidePadding),
      backgroundColor: context.colors.surface,
      showShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.spMin,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (title.isNotEmpty)
                CustomTypography(text: title, fontType: FontType.body2Semibold),
              CustomContainer(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.spMin,
                  vertical: 6.spMin,
                ),
                borderRadius: BorderRadius.circular(8.r),
                backgroundColor: color.normal,
                child: CustomTypography(
                  text: '$startDate - $endDate',
                  fontType: FontType.label2Regular,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 160.spMin,
            child: BarChart(
              BarChartData(
                maxY: chartMax,
                minY: 0,
                alignment: BarChartAlignment.spaceAround,
                barTouchData: BarTouchData(
                  enabled: !hideBalance,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      if (groupIndex < 0 || groupIndex >= trend.length) {
                        return null;
                      }
                      final point = trend[groupIndex];
                      return BarTooltipItem(
                        CurrencyFormatter.format(
                          point.amount,
                          currency: currency,
                          compact: true,
                        ),
                        CustomTypography(
                          color: Colors.white,
                        ).getTextStyle(context),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24.spMin,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= trend.length) {
                          return const SizedBox.shrink();
                        }
                        if (index % labelStep != 0 &&
                            index != trend.length - 1) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 4.spMin),
                          child: CustomTypography(
                            text: trend[index].title,
                            fontType: FontType.label2Medium,
                            color: context.colors.onSurface,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  for (var i = 0; i < trend.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: trend[i].amount,
                          width: _barWidth(trend.length),
                          borderRadius: BorderRadius.circular(4.r),
                          color: color.normal,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _labelStep(int count) {
    if (count <= 8) return 1;
    if (count <= 16) return 2;
    if (count <= 31) return 5;
    return 7;
  }

  double _barWidth(int count) {
    if (count <= 7) return 14.spMin;
    if (count <= 14) return 8.spMin;
    if (count <= 31) return 5.spMin;
    return 10.spMin;
  }
}
