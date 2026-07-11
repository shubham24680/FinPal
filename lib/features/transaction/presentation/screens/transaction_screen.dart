import 'package:finpal/app/app.dart';

class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final transactions = ref.watch(transactionProvider);
    final options = ref.watch(optionNotifer).value;
    final topPadding =
        AppConstants.sidePadding + MediaQuery.of(context).padding.top;
    final bottomPadding = 80.w + MediaQuery.of(context).padding.bottom;
    final padding = EdgeInsets.only(
      left: AppConstants.sidePadding,
      right: AppConstants.sidePadding,
      top: topPadding,
      bottom: bottomPadding,
    );
    final title = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTypography(text: "Transactions", fontType: FontType.h1Bold),
        CustomContainer(
          onTap: () async {
            final date = await chooseDate(context, selectedDate.formatDate());
            ref.read(selectedDateProvider.notifier).state = date.parseDate();
          },
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4.w,
            children: [
              CustomTypography(
                text: selectedDate.formatDate(type: DateFormatType.monthYear),
                fontType: FontType.label1SemiBold,
              ),
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: AppSvgs.arrowDownSmall,
              ),
            ],
          ),
        ),
      ],
    );

    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16.spMin,
      children: [
        _buildTopWidget(context, ref),
        _buildNoTransactions(context),
        // _buildTransctionList(context, ref),
      ],
    );

    return child;

    // return SingleChildScrollView(
    //   padding: EdgeInsets.only(bottom: 180.spMin),
    //   child: child,
    // );

    // return transactions.when(
    //   data: (data) {
    //     final monthlyTransactions = data.getMonthlyTransactions(selectedDate);
    //     if (monthlyTransactions.isEmpty) {
    //       return Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         spacing: 16.w,
    //         children: [
    //           title,
    //           Expanded(
    //             child: Center(
    //               child: CustomTypography(
    //                 text: "No transactions yet",
    //                 fontType: FontType.body1Medium,
    //                 color: BGColors.shade700,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ).padding(padding: padding);
    //     }

    //     return SingleChildScrollView(
    //       padding: padding,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         spacing: 16.w,
    //         children: [
    //           title,
    //           ...monthlyTransactions.map(
    //             (dayTx) => buildDayTransaction(context, ref, dayTx, options),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    //   loading: () => const Center(child: CircularProgressIndicator()),
    //   error:
    //       (error, stackTrace) =>
    //           _buildError(ref, title).padding(padding: padding),
    // );
  }

  Widget _buildTopWidget(BuildContext context, WidgetRef ref) {
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
              _buildTransactionOverview(context, ref),
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

  Widget _buildTransactionOverview(BuildContext context, WidgetRef ref) {
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
              ),
              _buildTransactionOverviewItem(
                context,
                "Total Income",
                AppSvgs.arrowUp,
                ColorSet.primary,
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
    double? amount,
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
            text: CurrencyFormatter.format(amount),
            fontType: FontType.h4Semibold,
            color: color.normal,
          ),
        ],
      ),
    );
  }

  Widget _buildNoTransactions(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 40.spMin),
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
            onTap: () => context.push(AppRoutesPath.editTransaction.path),
          ),
        ],
      ).padding(horizontal: AppConstants.sidePadding),
    );
  }

  Widget _buildTransctionList(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTypography(
          text: "May 2024",
          fontType: FontType.body1Semibold,
          color: Colors.white,
        ),
      ],
    ).padding(horizontal: AppConstants.sidePadding);
  }

  Widget _buildError(WidgetRef ref, Widget title) {
    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: title),
        const Spacer(),
        CustomTypography(
          text: "Something went wrong",
          fontType: FontType.body1Medium,
        ),
        SizedBox(height: 8.w),
        CustomButton(
          label: "Retry",
          isFull: false,
          onTap: () => ref.invalidate(transactionProvider),
        ),
        const Spacer(),
      ],
    );
  }

  Widget buildDayTransaction(
    BuildContext context,
    WidgetRef ref,
    List<PaymentModel> transactions,
    OptionServices? options,
  ) {
    if (transactions.isEmpty) return const SizedBox.shrink();

    final now = DateTime.now();
    final date = transactions.first.date;
    String transactionsDate;
    if (date == now.formatDate()) {
      transactionsDate = "Today";
    } else if (date ==
        DateTime(now.year, now.month, now.day - 1).formatDate()) {
      transactionsDate = "Yesterday";
    } else {
      // transactionsDate = date;
      transactionsDate = date.formatDate();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.w,
      children: [
        CustomTypography(
          text: transactionsDate,
          fontType: FontType.body2Semibold,
        ),
        CustomContainer(
          backgroundColor: BGColors.shade500,
          padding: EdgeInsets.zero,
          child: buildExpenses(
            context,
            ref,
            transactions,
            options,
            enableSwipe: true,
          ),
        ),
      ],
    );
  }
}
