import 'package:finpal/app/app.dart';

class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 180.spMin),
      child: Column(
        children: [
          _buildTopWidget(context, transactions),
          _buildMainWidget(context, transactions),
        ],
      ),
    );
  }

  Widget _buildTopWidget(
    BuildContext context,
    AsyncValue<TransactionService> transactions,
  ) {
    final topPadding = AppConstants.sidePadding + context.viewPadding.top;
    final data = transactions.value;
    final analysis = AnalysisCalculator.getAnalysis(
      data?.totalIncome,
      data?.totalExpense,
      data?.availableBalance,
    );

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
              AnalysisCard(analysis),
            ],
          ).padding(top: topPadding),
        ],
      ),
    );
  }

  Widget _buildMainWidget(
    BuildContext context,
    AsyncValue<TransactionService> transactions,
  ) {
    final period = ref.watch(analysisPeriodProvider);
    final options = ref.watch(optionNotifer).value;
    final currency = ref.watch(currencyProvider);
    final budgetCeiling = ref.watch(settingsNotifier).value?.monthlyBudget;

    return Column(
      children: [
        transactions.when(
          data: (data) {
            final analysisCompute = AnalysisCalculator.compute(
              payments: data.payments,
              period: period,
              expenseCategories: options?.expenseCategories ?? const [],
              paymentMethods: options?.paymentMethods ?? const [],
              fallbackCategory: OptionsConstant.otherCategory,
              fallbackMethod: OptionsConstant.otherCategory,
              budgetCeiling: budgetCeiling,
              currency: currency,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AnalysisPeriodChips().padding(top: 16.spMin),
                AnalysisInsightsRow(
                  insights: analysisCompute.insights,
                ).padding(horizontal: AppConstants.sidePadding, top: 16.spMin),
                AnalysisTrendChart(
                  analysis: analysisCompute,
                  hideBalance: false,
                ).padding(horizontal: AppConstants.sidePadding, top: 16.spMin),
                AnalysisSummaryStrip(
                  analysis: analysisCompute,
                  hideBalance: false,
                ).padding(horizontal: AppConstants.sidePadding, top: 16.spMin),
                AnalysisBudgetProgress(
                  analysis: analysisCompute,
                  hideBalance: false,
                ).padding(horizontal: AppConstants.sidePadding, top: 16.spMin),
                AnalysisCategoryBreakdown(
                  analysis: analysisCompute,
                  hideBalance: false,
                ).padding(horizontal: AppConstants.sidePadding, top: 16.spMin),
                AnalysisMethodBreakdown(
                  analysis: analysisCompute,
                  hideBalance: false,
                ).padding(horizontal: AppConstants.sidePadding, top: 16.spMin),
              ],
            );
          },
          error: (error, stackTrace) => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
        ),
      ],
    );
  }

  // Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
  //   return Column(
  //     children: [
  //       SizedBox(height: 24.w),
  //       CustomImage(
  //         imageUrl: AppImages.noTransactions,
  //       ).padding(horizontal: 40.spMin),
  //       SizedBox(height: 16.w),
  //       CustomTypography(
  //         text: 'No transactions this period',
  //         fontType: FontType.h4Semibold,
  //       ),
  //       SizedBox(height: 8.w),
  //       CustomTypography(
  //         text:
  //             'Add income or expenses to see your spending analysis for this period.',
  //         fontType: FontType.label1Medium,
  //         color: context.colors.onSurface,
  //         align: TextAlign.center,
  //       ),
  //       SizedBox(height: 16.w),
  //       CustomButton(
  //         label: 'Add Transaction',
  //         prefixIcon: AppSvgs.add2,
  //         onTap: () {
  //           ref.read(selectedTransactionProvider.notifier).state = null;
  //           context.push(AppRoutesPath.editTransaction.path);
  //         },
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildError(BuildContext context, WidgetRef ref) {
  //   return Column(
  //     children: [
  //       Align(
  //         alignment: Alignment.centerLeft,
  //         child: _buildGreeting(context, ref),
  //       ),
  //       const Spacer(),
  //       CustomTypography(
  //         text: 'Something went wrong',
  //         fontType: FontType.body1Medium,
  //       ),
  //       SizedBox(height: 8.w),
  //       CustomButton(
  //         label: 'Retry',
  //         isFull: false,
  //         onTap: () => ref.invalidate(transactionProvider),
  //       ),
  //       const Spacer(),
  //     ],
  //   );
  // }
}
