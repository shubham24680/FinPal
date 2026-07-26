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
      // Filters key is gone (e.g. empty list) — hide sticky app bar.
      final isVisible = ref.read(transactionOverviewProvider(id));
      if (isVisible) {
        ref.read(transactionOverviewProvider(id).notifier).state = false;
      }
      return;
    }

    final box = overviewContext.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final overviewTop = box.localToGlobal(Offset.zero).dy + offset;
    final statusBarHeight = MediaQuery.paddingOf(context).top;
    final shouldShow = overviewTop < statusBarHeight;
    final isVisible = ref.read(transactionOverviewProvider(id));
    if (shouldShow == isVisible) return;
    ref.read(transactionOverviewProvider(id).notifier).state = shouldShow;
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
    final isFiltersVisible = ref.watch(transactionOverviewProvider("filters"));

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
          return noTransactionsWidget;
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
                      (dayGroups) =>
                          _buildTransctionList(context, ref, dayGroups),
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

  Widget _buildFilters(
    BuildContext context,
    DateTime selectedDate,
    TransactionType? typeFilter,
  ) {
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
            onTap: () async {
              final picked = await CustomBottomSheet.chooseDate(
                context,
                date: selectedDate,
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
      onTap: () => context.push(AppRoutesPath.profile.path),
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
                AppSvgs.arrowDown,
                ColorSet.error,
                amount: totalExpense,
              ),
              _buildTransactionOverviewItem(
                context,
                "Total Income",
                AppSvgs.arrowUp,
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

  Widget _buildNoTransactions(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 20.spMin),
          CustomImage(
            imageUrl: AppImages.noTransactions,
          ).padding(horizontal: 60.spMin),
          CustomTypography(
            text: "No transactions yet",
            fontType: FontType.h4Semibold,
          ),
          SizedBox(height: 8.spMin),
          CustomTypography(
            text:
                "You haven't made any transactions yet.\nStart by adding income or expenses to track your spending.",
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

  Widget _buildTransctionList(
    BuildContext context,
    WidgetRef ref,
    List<PaymentModel> dayGroups,
  ) {
    if (dayGroups.isEmpty) return const SizedBox.shrink();
    final date = dayGroups.first.date.getDateLabel(type: DateFormatType.date1);
    final options = ref.watch(optionNotifer).value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.spMin,
      children: [
        CustomTypography(
          text: date,
          fontType: FontType.body2Semibold,
          color: context.colors.onSurface,
        ),
        CustomContainer(
          backgroundColor: context.colors.surface,
          padding: EdgeInsets.zero,
          child: ListView.separated(
            itemCount: dayGroups.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder:
                (context, index) => _buildTransactionTile(
                  context,
                  ref,
                  dayGroups[index],
                  options,
                ),
            separatorBuilder: (context, index) => Divider(),
          ),
        ),
      ],
    ).padding(horizontal: AppConstants.sidePadding);
  }

  Widget _buildTransactionTile(
    BuildContext context,
    WidgetRef ref,
    PaymentModel payment,
    OptionServices? options,
  ) {
    final isDark = context.isDarkMode;
    final category = options?.findById(payment.categoryId);
    final color = category?.color.colorSet ?? ColorSet.primary;
    final title = payment.notes.isEmpty ? "Other" : payment.notes;
    final isExpense = payment.paymentType == TransactionType.expense.id;

    return CustomContainer(
      onTap: () {
        ref.read(selectedTransactionProvider.notifier).state = payment;
        context.push(AppRoutesPath.editTransaction.path);
      },
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16.spMin, vertical: 12.spMin),
      child: Row(
        spacing: 12.spMin,
        children: [
          if (category != null)
            CustomContainer(
              padding: EdgeInsets.all(12.r),
              backgroundColor: isDark ? color.dimDark : color.light,
              child: CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: category.icon,
                color: color.normal,
                height: 16.spMin,
                width: 16.spMin,
              ),
            ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2.spMin,
              children: [
                CustomTypography(
                  text: title,
                  fontType: FontType.body2Medium,
                  maxLines: 1,
                ),
                if (category != null)
                  CustomTypography(
                    text: category.name,
                    fontType: FontType.label1Regular,
                    color: context.colors.onSurfaceVariant,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 2.spMin,
            children: [
              CustomTypography(
                text: CurrencyFormatter.signed(
                  payment.amount,
                  isExpense: isExpense,
                ),
                fontType: FontType.body2Semibold,
                color:
                    isExpense
                        ? context.colors.inverseSurface
                        : context.successColor,
              ),
              CustomTypography(
                text: payment.date.formatDate(type: DateFormatType.time),
                fontType: FontType.label1Medium,
                color: context.colors.onSurface,
              ),
            ],
          ),
          CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: AppSvgs.arrowRight1,
            color: context.colors.onSurfaceVariant,
            height: 16.spMin,
          ),
        ],
      ),
    );
  }
}
