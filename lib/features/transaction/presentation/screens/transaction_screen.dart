import 'package:finpal/app/app.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key});

  @override
  ConsumerState<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  final GlobalKey _filtersKey = GlobalKey();

  void _updateAppBarVisibility(GlobalKey key, String id, {double offset = 0}) {
    final overviewContext = key.currentContext;
    if (overviewContext == null) {
      final isVisible = ref.read(transactionAppbarProvider(id));
      if (isVisible) {
        ref.read(transactionAppbarProvider(id).notifier).state = false;
      }
      return;
    }

    final box = overviewContext.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final overviewTop = box.localToGlobal(Offset.zero).dy + offset;
    final statusBarHeight = MediaQuery.paddingOf(context).top;
    final shouldShow = overviewTop < statusBarHeight;
    final isVisible = ref.read(transactionAppbarProvider(id));
    if (shouldShow == isVisible) return;
    ref.read(transactionAppbarProvider(id).notifier).state = shouldShow;
  }

  void _scheduleAppBarVisibilityCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _updateAppBarVisibility(_filtersKey, "filters", offset: -20.spMin);
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final typeFilter = ref.watch(transactionTypeFilterProvider);
    final isFiltersVisible = ref.watch(transactionAppbarProvider("filters"));

    final noTransactionsWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.spMin,
      children: [
        _buildTopWidget(context, 0, 0),
        _buildFilters(context, selectedDate, typeFilter),
        _buildNoTransactions(context, ref),
      ],
    );

    return transactions.when(
      data: (data) {
        final monthPayments = data.getMonthlyTransactions(selectedDate);
        final filteredPayments = data.filterTransactions(
          monthPayments,
          typeFilter,
        );
        if (filteredPayments.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.spMin,
            children: [
              _buildTopWidget(context, 0, 0),
              _buildFilters(context, selectedDate, typeFilter),
              _buildNoTransactions(context, ref, title: "No matching transactions"),
            ],
          );
        }

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                _updateAppBarVisibility(
                  _filtersKey,
                  "filters",
                  offset: -20.spMin,
                );
                return false;
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 180.spMin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.spMin,
                  children: [
                    _buildTopWidget(
                      context,
                      data.totalIncome,
                      data.totalExpense,
                    ),
                    KeyedSubtree(
                      key: _filtersKey,
                      child: _buildFilters(context, selectedDate, typeFilter),
                    ),
                    ...filteredPayments.map(
                      (dayGroups) => TransactionList(payments: dayGroups),
                    ),
                  ],
                ),
              ),
            ),
            CustomContainer(
              padding: EdgeInsets.only(
                top: AppConstants.sidePadding + context.viewPadding.top,
                bottom: AppConstants.sidePadding,
              ),
              showShadow: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 16.spMin,
                children: [
                  if (isFiltersVisible)
                    _buildFilters(context, selectedDate, typeFilter),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => noTransactionsWidget,
      error: (error, stackTrace) => noTransactionsWidget,
    );
  }

  Widget _buildTopWidget(
    BuildContext context,
    double totalIncome,
    double totalExpense,
  ) {
    final topPadding = AppConstants.sidePadding + context.viewPadding.top;

    return SizedBox(
      height: 320.spMin,
      child: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          CustomImage(
            imageUrl:
                context.isDarkMode ? AppImages.bannerDark : AppImages.banner,
          ).padding(bottom: 54.spMin),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16.spMin,
            children: [
              CustomTypography(text: "Transactions", fontType: FontType.h1Bold),
              CustomTypography(
                text: "Track and manage your transactions",
                fontType: FontType.body2Medium,
                color: context.colors.onSurface,
              ),
              Spacer(),
              _buildTransactionOverview(context, totalIncome, totalExpense),
            ],
          ).padding(
            left: AppConstants.sidePadding,
            right: AppConstants.sidePadding,
            top: topPadding,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionOverview(
    BuildContext context,
    double totalIncome,
    double totalExpense,
  ) {
    return CustomContainer(
      backgroundColor: context.colors.surface,
      showShadow: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.spMin,
        children: [
          CustomTypography(
            text: "Overview",
            fontType: FontType.body2Semibold,
            color: context.colors.inverseSurface,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 16.spMin,
            children: [
              _buildTransactionOverviewItem(
                context,
                "Total Spendings",
                AppSvgs.arrowUp,
                ColorSet.error,
                amount: totalExpense,
              ),
              _buildTransactionOverviewItem(
                context,
                "Total Income",
                AppSvgs.arrowDown,
                ColorSet.primary,
                amount: totalIncome,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionOverviewItem(
    BuildContext context,
    String title,
    String icon,
    ColorSet color, {
    double amount = 0,
  }) {
    final isDark = context.isDarkMode;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.spMin,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4.spMin,
            children: [
              CustomTypography(
                text: title,
                fontType: FontType.label1Bold,
                color: context.colors.onSurface,
              ),
              Container(
                width: 16.spMin,
                height: 16.spMin,
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  color: isDark ? color.dimDark : color.light,
                  shape: BoxShape.circle,
                ),
                child: CustomImage(
                  imageType: ImageType.svgLocal,
                  imageUrl: icon,
                  color: color.normal,
                ),
              ),
            ],
          ),
          CustomTypography(
            overflow: TextOverflow.ellipsis,
            text: CurrencyFormatter.format(amount, compact: amount.abs() > 1e7),
            fontType: FontType.h4Semibold,
            color: color.normal,
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(
    BuildContext context,
    DateTime selectedDate,
    TransactionType? typeFilter,
  ) {
    final isDark = context.isDarkMode;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: AppConstants.sidePadding),
      child: Row(
        spacing: 8.spMin,
        children: [
          CustomChip(
            label: selectedDate.formatDate(type: DateFormatType.monthYear),
            imageUrl: AppSvgs.calendar,
            selected: true,
            outlined: true,
            backgroundColor:
                isDark
                    ? AppColors.primary700.withAlpha(100)
                    : AppColors.primary50,
            foregroundColor: AppColors.primary500,
            borderColor: AppColors.primary700,
            onTap: () async {
              final picked = await CustomBottomSheet.chooseDate(
                context,
                date: selectedDate,
                onlyMonths: true,
              );
              if (picked == null || !mounted) return;
              ref.read(selectedDateProvider.notifier).state = picked;
              _scheduleAppBarVisibilityCheck();
            },
          ),
          CustomChip(
            label: "All",
            selected: typeFilter == null,
            outlined: true,
            variant:
                typeFilter == null ? ChipVariant.primary : ChipVariant.inactive,
            onTap: () {
              ref.read(transactionTypeFilterProvider.notifier).state = null;
              _scheduleAppBarVisibilityCheck();
            },
          ),
          ...TransactionType.values.map((type) {
            final selected = typeFilter == type;
            return CustomChip(
              label: type.name,
              imageUrl: type.icon,
              selected: selected,
              outlined: true,
              variant: selected ? ChipVariant.primary : ChipVariant.inactive,
              onTap: () {
                ref.read(transactionTypeFilterProvider.notifier).state = type;
                _scheduleAppBarVisibilityCheck();
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNoTransactions(
    BuildContext context,
    WidgetRef ref, {
    String title = "No transactions yet",
    String description =
        "You haven't made any transactions yet.\nStart by adding income or expenses to track your spending.",
  }) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 20.spMin),
          CustomImage(
            imageUrl: AppImages.noTransactions,
          ).padding(horizontal: 60.spMin),
          CustomTypography(text: title, fontType: FontType.h4Semibold),
          SizedBox(height: 8.spMin),
          CustomTypography(
            text: description,
            fontType: FontType.label1Medium,
            color: context.colors.onSurface,
            align: TextAlign.center,
          ),
          SizedBox(height: 16.spMin),
          CustomButton(
            label: "Add Transaction",
            prefixIcon: AppSvgs.add2,
            onTap: () {
              ref.read(selectedTransactionProvider.notifier).state = null;
              context.push(AppRoutesPath.editTransaction.path);
            },
          ),
        ],
      ).padding(horizontal: AppConstants.sidePadding),
    );
  }
}
