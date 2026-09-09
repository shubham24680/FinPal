import 'package:finpal/app/app.dart';

class CategoryDetailScreen extends ConsumerWidget {
  const CategoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryId = ref.watch(selectedCategoryIdProvider);
    final month = ref.watch(categoriesMonthProvider);
    final options = ref.watch(optionNotifer).value;
    final payments = ref.watch(transactionProvider).value?.payments ?? [];
    if (categoryId == null || options == null) {
      return Scaffold(
        appBar: customAppBar(context, title: 'Category'),
        body: const Center(child: CustomTypography(text: 'Category not found')),
      );
    }
    final category = options.findById(categoryId);
    final analysis = AnalysisCalculator.categoryMonthAnalysis(
      categoryId: categoryId,
      month: month,
      payments: payments,
      category: category,
      paymentMethods: options.paymentMethods,
    );
    final dayGroups = _dayGroupsForCategory(payments, categoryId, month);
    return Scaffold(
      appBar: customAppBar(context, title: category.name),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 40.spMin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.spMin,
          children: [
            _buildSummaryCard(context, ref, analysis),
            if (analysis.trend.any((e) => e.amount > 0))
              AnalysisTrendChart(
                analysis.trend,
                AnalysisPeriod.thisMonth,
                title: 'Spending trend',
                color: analysis.summary.color,
                dateRange: analysis.range,
              ),
            if (analysis.methods.isNotEmpty)
              _buildMethodsSection(context, analysis),
            if (dayGroups.isEmpty) ...[
              SizedBox(height: 16.spMin),
              _buildNoTransactions(context)
            ]
            else
              ...dayGroups.map(
                (dayPayments) => TransactionList(payments: dayPayments),
              ),
          ],
        ).padding(top: AppConstants.sidePadding),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    WidgetRef ref,
    CategoryMonthAnalysis analysis,
  ) {
    final summary = analysis.summary;
    final color = summary.color;
    final amount = ref.formatCurrency(summary.amount);
    final percentage = '${summary.percentage.toStringAsFixed(0)}%';
    return CustomContainer(
      showShadow: true,
      margin: EdgeInsets.symmetric(horizontal: AppConstants.sidePadding),
      gradient: RadialGradient(
        center: Alignment.bottomRight,
        colors: [
          color.normal.withAlpha(40),
          context.isDarkMode ? color.dimDark : color.extraLight,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 28.spMin,
        children: [
          Row(
            spacing: 12.spMin,
            children: [
              CustomContainer(
                height: 48.spMin,
                width: 48.spMin,
                padding: EdgeInsets.all(10.spMin),
                backgroundColor:
                    context.isDarkMode ? color.dimDark : color.light,
                child: CustomImage(
                  imageType: ImageType.svgLocal,
                  imageUrl: summary.icon ?? AppSvgs.bin,
                  color: color.normal,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2.spMin,
                  children: [
                    CustomTypography(
                      text: summary.title,
                      fontType: FontType.body2Semibold,
                    ),
                    CustomTypography(
                      text: 'of month expenses',
                      fontType: FontType.label2Regular,
                      color: context.colors.onSurface,
                    ),
                  ],
                ),
              ),
              CustomTypography(
                text: percentage,
                fontType: FontType.h4Semibold,
                color: color.normal,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.spMin,
            children: [
              CustomTypography(text: amount, fontType: FontType.h3Bold),
              CustomTypography(
                text: '${summary.count} transactions this month',
                fontType: FontType.label1Medium,
                color: context.colors.onSurface,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMethodsSection(
    BuildContext context,
    CategoryMonthAnalysis analysis,
  ) {
    final total = analysis.summary.amount;
    return CustomContainer(
      showShadow: true,
      margin: EdgeInsets.symmetric(horizontal: AppConstants.sidePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.spMin,
        children: [
          CustomTypography(
            text: 'Payment methods',
            fontType: FontType.body2Semibold,
          ),
          ...analysis.methods.map((method) {
            final color = method.color;
            final icon = method.icon ?? AppSvgs.bin;
            final percentage = '${method.percentage.toStringAsFixed(0)}%';
            final fraction = total > 0 ? method.amount / total : 0.0;
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
                      text:
                          '${method.count} items ${UnicodeConstants.dot} $percentage',
                      fontType: FontType.label2Regular,
                      color: context.colors.onSurface,
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: LinearProgressIndicator(
                    value: fraction.clamp(0.0, 1.0),
                    minHeight: 6.spMin,
                    backgroundColor: context.colors.surfaceContainerHighest,
                    color: color.normal,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNoTransactions(BuildContext context) {
    final isLandscape = context.isLandscape;

    return Center(child: Column(
      children: [
        SizedBox(height: 12.spMin),
        CustomImage(
          imageUrl: AppImages.noTransactions,
          height: 200.spMin,
        ).padding(horizontal: 60.spMin),
        CustomTypography(
          text: 'No transactions this month',
          fontType: FontType.h4Semibold,
        ),
        SizedBox(height: 8.spMin),
        CustomTypography(
          text: 'Try another month or add expenses in this category.',
          fontType: FontType.label1Medium,
          color: context.colors.onSurface,
          align: TextAlign.center,
        ),
        SizedBox(height: 8.spMin),
        CustomButton(
          prefixIcon: AppSvgs.add2,
          label: 'Add transaction',
          isFull: !isLandscape,
          onTap: () => context.push(AppRoutesPath.editTransaction.path),
        )
      ],
    )).padding(horizontal: AppConstants.sidePadding);
  }

  List<List<PaymentModel>> _dayGroupsForCategory(
    List<PaymentModel> payments,
    String categoryId,
    DateTime month,
  ) {
    final byDay = <DateTime, List<PaymentModel>>{};
    for (final payment in payments) {
      if (payment.categoryId != categoryId) continue;
      if (!payment.date.isSameMonthAs(month)) continue;
      final day = payment.date.startOfDay;
      (byDay[day] ??= []).add(payment);
    }
    final days = byDay.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final day in days)
        byDay[day]!..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
    ];
  }
}
