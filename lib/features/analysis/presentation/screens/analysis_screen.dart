import 'package:finpal/app/app.dart';

class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    final period = ref.watch(analysisPeriodProvider);
    final transactions = ref.watch(transactionProvider);
    final payments = transactions.value?.payments ?? const [];
    final options = ref.watch(optionNotifer).value;
    final currency = ref.watch(currencyProvider);
    final month = ref.watch(categoriesMonthProvider);
    final analysis = AnalysisCalculator.compute(
      period: period,
      payments: payments,
      expenseCategories: options?.expenseCategories ?? const [],
      paymentMethods: options?.paymentMethods ?? const [],
      currency: currency,
      fallbackCategory: OptionsConstant.otherCategory,
      fallbackMethod: OptionsConstant.otherCategory,
      month: month,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 180.spMin),
      child: Column(
        children: [
          _buildTopWidget(context, analysis),
          _buildMainWidget(context, analysis, month),
        ],
      ),
    );
  }

  Widget _buildTopWidget(BuildContext context, PeriodAnalysis analysis) {
    final topPadding = AppConstants.sidePadding + context.viewPadding.top;
    final pieData = analysis.analysisPie;

    return SizedBox(
      height: 340.spMin,
      child: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          CustomImage(
            imageUrl:
                context.isDarkMode ? AppImages.bannerDark : AppImages.banner,
          ).padding(bottom: 74.spMin),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16.spMin,
            children: [
              CustomTypography(
                text: "Analysis",
                fontType: FontType.h1Bold,
              ).padding(horizontal: AppConstants.sidePadding),
              CustomTypography(
                text: "Analyze your spending and income",
                fontType: FontType.body2Medium,
                color: context.colors.onSurface,
              ).padding(horizontal: AppConstants.sidePadding),
              Spacer(),
              AnalysisCard(pieData),
            ],
          ).padding(top: topPadding),
        ],
      ),
    );
  }

  Widget _buildMainWidget(
    BuildContext context,
    PeriodAnalysis analysis,
    DateTime month,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.spMin,
      children: [
        // const AnalysisPeriodChips(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTypography(
              text: month.formatDate(type: DateFormatType.monthYear),
              fontType: FontType.body2Bold,
            ),
            CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: AppSvgs.filter,
              onClick: () async {
                final picked = await CustomBottomSheet.chooseDate(
                  context,
                  date: month,
                  onlyMonths: true,
                );
                if (picked == null || !context.mounted) return;
                ref.read(categoriesMonthProvider.notifier).state = picked;
              },
            ),
          ],
        ).padding(horizontal: 8.spMin + AppConstants.sidePadding),
        AnalysisTrendChart(
          analysis.expenseTrend,
          analysis.period,
          title: 'Spending trend',
          dateRange: DateTimeRange(
            start: month.startOfMonth,
            end: month.endOfMonth,
          ),
        ),
        AnalysisTrendChart(
          analysis.incomeTrend,
          analysis.period,
          title: 'Income trend',
          color: ColorSet.info,
          dateRange: DateTimeRange(
            start: month.startOfMonth,
            end: month.endOfMonth,
          ),
        ),
        AnalysisBreakdown(analysis),
        AnalysisBreakdown1(analysis),
      ],
    ).padding(vertical: AppConstants.sidePadding);
  }
}
