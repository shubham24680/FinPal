import 'package:finpal/app/app.dart';

class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);

    final topPadding =
        AppConstants.sidePadding + MediaQuery.of(context).padding.top;
    final bottomPadding = 80.w + MediaQuery.of(context).padding.bottom;
    final padding = EdgeInsets.only(
      left: AppConstants.sidePadding,
      right: AppConstants.sidePadding,
      top: topPadding,
      bottom: bottomPadding,
    );
    final title = CustomTypography(
      text: "Transactions",
      fontType: FontType.h1Bold,
    );

    return transactions.when(
      data: (data) {
        final montlyTransactions = data.getMonthlyTransactions();
        if (montlyTransactions.isEmpty) {
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
              ...montlyTransactions.map(
                (transactions) => buildDayTransaction(context, transactions),
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
    List<PaymentModel> transactions,
  ) {
    if (transactions.isEmpty) return const SizedBox.shrink();

    final now = DateTime.now();
    final date = transactions.first.date;
    String transactionsDate;
    if (date == formatDate(now)) {
      transactionsDate = "Today";
    } else if (date == formatDate(DateTime(now.year, now.month, now.day - 1))) {
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
          child: buildExpenses(context, transactions),
        ),
      ],
    );
  }
}
