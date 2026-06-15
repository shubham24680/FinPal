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
            ref.read(selectedDateProvider.notifier).state = parseDate(date);
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
                imageUrl: AppSvgs.arrowDown,
              ),
            ],
          ),
        ),
      ],
    );

    return transactions.when(
      data: (data) {
        final monthlyTransactions = data.getMonthlyTransactions(selectedDate);
        if (monthlyTransactions.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.w,
            children: [
              title,
              Expanded(
                child: Center(
                  child: CustomTypography(
                    text: "No transactions yet",
                    fontType: FontType.body1Medium,
                    color: BGColors.shade700,
                  ),
                ),
              ),
            ],
          ).padding(padding: padding);
        }

        return SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.w,
            children: [
              title,
              ...monthlyTransactions.map(
                (dayTx) => buildDayTransaction(context, ref, dayTx, options),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (error, stackTrace) =>
              _buildError(ref, title).padding(padding: padding),
    );
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
      transactionsDate = date;
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
