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
    final analysis = AnalysisCalculator.compute(
      period: period,
      payments: payments,
      expenseCategories: options?.expenseCategories ?? const [],
      paymentMethods: options?.paymentMethods ?? const [],
      currency: currency,
      fallbackCategory: OptionsConstant.otherCategory,
      fallbackMethod: OptionsConstant.otherCategory,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 180.spMin),
      child: Column(
        children: [
          _buildTopWidget(context, analysis),
          _buildMainWidget(context, analysis),
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

  Widget _buildMainWidget(BuildContext context, PeriodAnalysis analysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.spMin,
      children: [
        const AnalysisPeriodChips(),
        AnalysisTrendChart(
          analysis.expenseTrend,
          analysis.period,
          title: 'Spending trend',
        ),
        AnalysisTrendChart(
          analysis.incomeTrend,
          analysis.period,
          title: 'Income trend',
          color: ColorSet.info,
        ),
        AnalysisCategoryBreakdown(analysis),
        AnalysisMethodBreakdown(analysis),
      ],
    ).padding(vertical: AppConstants.sidePadding);
  }
}
