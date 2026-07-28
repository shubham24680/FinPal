import 'package:finpal/app/app.dart';

class AnalysisScreen extends ConsumerStatefulWidget {
  const AnalysisScreen({super.key});

  @override
  ConsumerState<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends ConsumerState<AnalysisScreen> {
  static const _topWidgetHeight = 266.0;
  static const _fullSheetThreshold = 0.85;

  final ValueNotifier<bool> _isSheetExpanded = ValueNotifier(false);

  @override
  void dispose() {
    _isSheetExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsNotifier).value;
    final transactions = ref.watch(transactionProvider);

    final availableBalance = transactions.value?.availableBalance ?? 0;
    final hideBalance = settings?.hideBalanceOnHome ?? false;

    return Stack(
      children: [
        _buildTopWidget(context, availableBalance, hideBalance),
        _buildMainWidget(context, transactions, hideBalance),
        _buildAppBar(context, availableBalance, hideBalance),
      ],
    );
  }

  Widget _buildTopWidget(
    BuildContext context,
    double availableBalance,
    bool hideBalance,
  ) {
    final topPadding = AppConstants.sidePadding + context.viewPadding.top;
    final profile = ref.watch(profileNotifier).value;
    final name = profile?.name.split(' ').first;
    final title = [
      TypographyModel(text: "Hello ", fontType: FontType.h1Medium),
      if (name != null && name.isNotEmpty)
        TypographyModel(text: "$name!", color: AppColors.primary500),
    ];
    final toggleBalance = ref.watch(hideBalanceProvider);

    return CustomContainer(
      height: _topWidgetHeight.spMin,
      width: double.infinity,
      padding: EdgeInsets.only(
        top: topPadding,
        left: AppConstants.sidePadding,
        right: AppConstants.sidePadding,
        bottom: 32.spMin,
      ),
      borderRadius: BorderRadius.zero,
      image: context.isDarkMode ? AppImages.bannerDark : AppImages.banner,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8.spMin,
            children: [
              Expanded(
                child: CustomTypography(
                  typos: title,
                  maxLines: 1,
                  align: TextAlign.start,
                ),
              ),
              _buildProfileActionButtons(context),
            ],
          ),
          SizedBox(height: 8.spMin),
          CustomTypography(
            text: "Let's make today\nfinancially rewarding.",
            fontType: FontType.body2Medium,
            color: context.colors.onSurface,
          ),
          Spacer(),
          Row(
            spacing: 8.spMin,
            crossAxisAlignment:
                hideBalance
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.end,
            children: [
              CustomTypography(
                text: "Total Balance",
                fontType: FontType.body2Medium,
              ),
              if (hideBalance)
                CustomImage(
                  imageType: ImageType.svgLocal,
                  imageUrl: toggleBalance ? AppSvgs.eyeOpen : AppSvgs.eyeClosed,
                  onClick:
                      () =>
                          ref.read(hideBalanceProvider.notifier).state =
                              !toggleBalance,
                  width: 16.spMin,
                  height: 16.spMin,
                ),
            ],
          ),
          SizedBox(height: 4.spMin),
          (!hideBalance || toggleBalance)
              ? CustomTypography(
                text: CurrencyFormatter.format(availableBalance),
                fontType: FontType.h1Bold,
              )
              : Row(
                spacing: 8.spMin,
                children: List.generate(
                  4,
                  (index) => CustomContainer(
                    padding: EdgeInsets.all(8.spMin),
                    borderRadius: BorderRadius.circular(1000.r),
                    backgroundColor: context.colors.inverseSurface,
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
    double availableBalance,
    bool hideBalance,
  ) {
    final topPadding = AppConstants.sidePadding + context.viewPadding.top;
    return ValueListenableBuilder<bool>(
      valueListenable: _isSheetExpanded,
      builder: (context, isExpanded, _) {
        return IgnorePointer(
          ignoring: !isExpanded,
          child: AnimatedOpacity(
            opacity: isExpanded ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: CustomContainer(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16.r),
              ),
              showShadow: true,
              padding: EdgeInsets.only(
                top: topPadding,
                left: AppConstants.sidePadding,
                right: AppConstants.sidePadding,
                bottom: 8.spMin,
              ),
              child: Row(
                spacing: 8.spMin,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildTotalBalance(
                      context,
                      availableBalance,
                      hideBalance,
                      smallFont: true,
                    ),
                  ),
                  _buildProfileActionButtons(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalBalance(
    BuildContext context,
    double availableBalance,
    bool hideBalance, {
    bool smallFont = false,
  }) {
    final toggleBalance = ref.watch(hideBalanceProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8.spMin,
          crossAxisAlignment:
              hideBalance ? CrossAxisAlignment.center : CrossAxisAlignment.end,
          children: [
            CustomTypography(
              text: "Total Balance",
              fontType:
                  smallFont ? FontType.label2Medium : FontType.body2Medium,
            ),
            if (hideBalance)
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: toggleBalance ? AppSvgs.eyeOpen : AppSvgs.eyeClosed,
                onClick:
                    () =>
                        ref.read(hideBalanceProvider.notifier).state =
                            !toggleBalance,
                height: smallFont ? 12.spMin : 16.spMin,
              ),
          ],
        ),
        SizedBox(height: smallFont ? 2.spMin : 4.spMin),
        (!hideBalance || toggleBalance)
            ? CustomTypography(
              text: CurrencyFormatter.format(availableBalance),
              fontType: smallFont ? FontType.h4Bold : FontType.h1Bold,
            )
            : Row(
              spacing: smallFont ? 4.spMin : 8.spMin,
              children: List.generate(
                4,
                (index) => CustomContainer(
                  padding: EdgeInsets.all(smallFont ? 4.spMin : 8.spMin),
                  borderRadius: BorderRadius.circular(1000.r),
                  backgroundColor: context.colors.inverseSurface,
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildProfileActionButtons(BuildContext context) {
    final profile = ref.watch(profileNotifier).value;

    return Row(
      spacing: 8.spMin,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomContainer(
          padding: EdgeInsets.all(10.spMin),
          borderRadius: BorderRadius.circular(1000.r),
          border: Border.all(color: context.colors.outline),
          showShadow: true,
          child: CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: AppSvgs.search,
            width: 20.spMin,
            height: 20.spMin,
          ),
        ),
        CustomContainer(
          showShadow: true,
          borderRadius: BorderRadius.circular(1000.r),
          border: Border.all(color: context.colors.outline),
          padding: EdgeInsets.all(10.spMin),
          child: CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: AppSvgs.notification,
            width: 20.spMin,
            height: 20.spMin,
          ),
        ),
        buildAvatar(
          context,
          showShadow: true,
          image: profile?.profileImage ?? "",
          size: 40.spMin,
          enableBorder: true,
          onTap: () => context.push(AppRoutesPath.profile.path),
        ),
      ],
    );
  }

  Widget _buildMainWidget(
    BuildContext context,
    AsyncValue<TransactionService> transactions,
    bool hideBalance,
  ) {
    final screenHeight = context.screenHeight;
    final collapsedSize = ((screenHeight - _topWidgetHeight.spMin + 24.spMin) /
            screenHeight)
        .clamp(0.35, 0.85);
    final period = ref.watch(analysisPeriodProvider);
    final options = ref.watch(optionNotifer).value;
    final currency = ref.watch(currencyProvider);
    final budgetCeiling = ref.watch(settingsNotifier).value?.monthlyBudget;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        final isExpanded = notification.extent >= _fullSheetThreshold;
        if (_isSheetExpanded.value != isExpanded) {
          _isSheetExpanded.value = isExpanded;
        }
        return false;
      },
      child: DraggableScrollableSheet(
        initialChildSize: collapsedSize,
        minChildSize: collapsedSize,
        maxChildSize: 0.9,
        snap: true,
        snapSizes: [collapsedSize],
        builder: (context, scrollController) {
          return ValueListenableBuilder<bool>(
            valueListenable: _isSheetExpanded,
            builder: (context, isExpanded, child) {
              return CustomContainer(
                padding: EdgeInsets.zero,
                backgroundColor: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(isExpanded ? 0 : 24.r),
                ),
                child: child,
              );
            },
            child: ListView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 8.spMin, bottom: 180.spMin),
              children: [
                Center(
                  child: CustomContainer(
                    width: 48.spMin,
                    height: 4.spMin,
                    borderRadius: BorderRadius.circular(1000.r),
                    backgroundColor: context.colors.onSurface.withAlpha(40),
                  ),
                ),
                SizedBox(height: 16.spMin),
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
                    final analysis = AnalysisCalculator.getAnalysis(
                      data.totalIncome,
                      data.totalExpense,
                      data.availableBalance,
                    );
                    final recentTransactions = data.getRecentTransactions();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const AnalysisPeriodChips(),
                        // SizedBox(height: 16.spMin),
                        AnalysisCard(analysis),
                        CategoriesCard(),
                        AnimatedTap(
                          onTap: () => ref.read(navProvider.notifier).state = 2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: CustomImage(
                              imageUrl: AppImages.reportPoster,
                            ),
                          ),
                        ).padding(all: AppConstants.sidePadding),
                        // AnalysisTrendChart(
                        //   analysis: analysisCompute,
                        //   hideBalance: hideBalance,
                        // ),
                        if (recentTransactions.isNotEmpty) ...[
                          TransactionList(
                            payments: recentTransactions,
                            label: "Recent Transactions",
                            labelColor: context.colors.onSurface,
                            moreButtonLabel: "View All",
                            showDate: true,
                            onMoreButtonPressed:
                                () => ref.read(navProvider.notifier).state = 1,
                          ),
                        ],
                        // AnalysisSummaryStrip(
                        //   analysis: analysis,
                        //   hideBalance: hideBalance,
                        // ),
                        // SizedBox(height: 16.spMin),
                        // AnalysisBudgetProgress(
                        //   analysis: analysisCompute,
                        //   hideBalance: hideBalance,
                        // ),
                        // SizedBox(height: 16.spMin),
                        // SizedBox(height: 16.spMin),
                        // AnalysisCategoryBreakdown(
                        //   analysis: analysisCompute,
                        //   hideBalance: hideBalance,
                        // ),
                        // SizedBox(height: 16.spMin),
                        // AnalysisMethodBreakdown(
                        //   analysis: analysisCompute,
                        //   hideBalance: hideBalance,
                        // ),
                        // SizedBox(height: 16.spMin),
                        // AnalysisInsightsRow(insights: analysisCompute.insights),
                        // SizedBox(height: 16.spMin),
                        // AnalysisRecentExpenses(
                        //   expenses: analysisCompute.recentExpenses,
                        // ),
                      ],
                    );
                  },
                  error: (error, stackTrace) => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
      ),
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
