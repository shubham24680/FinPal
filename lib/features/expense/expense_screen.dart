import 'package:finpal/app/app.dart';

class ExpenseScreen extends ConsumerWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionProvider);
    final options = ref.watch(optionNotifer).value?.expenseCategories ?? [];
    final topPadding =
        AppConstants.sidePadding + MediaQuery.of(context).padding.top;
    final bottomPadding =
        60.w + AppConstants.sidePadding + MediaQuery.of(context).padding.bottom;
    final padding = EdgeInsets.only(
      left: AppConstants.sidePadding,
      right: AppConstants.sidePadding,
      top: topPadding,
      bottom: bottomPadding,
    );

    return transactions.when(
      data: (data) {
        return SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSalution(ref),

              SizedBox(height: 16.w),
              balanceCard(data.getAnalysis()),
              SizedBox(height: 16.w),
              categoriesTiles(data.transactionByCategories(options)),
              SizedBox(height: 16.w),
              manageExpenses(ref, data.expenseTransactions.reversed.toList()),
            ],
          ),
        );
      },
      loading:
          () => const Center(
            child: CircularProgressIndicator(color: CardColors.shade1000),
          ),
      error: (error, stackTrace) => _buildError(ref).padding(padding: padding),
    );
  }

  Widget _buildError(WidgetRef ref) {
    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: _buildSalution(ref)),
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

  Widget _buildSalution(WidgetRef ref) {
    final profile = ref.watch(profileNotifier).value;
    final name = profile?.name?.split(" ").first;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          maxLines: 1,
          overflow: TextOverflow.clip,
          text: TextSpan(
            style: CustomTypography(fontType: FontType.h1Bold).getTextStyle(),
            children: [
              TextSpan(
                text: "Hello",
                style:
                    CustomTypography(
                      fontType: FontType.h1Semibold,
                    ).getTextStyle(),
              ),
              if (name != null && name.isNotEmpty) TextSpan(text: " $name!"),
            ],
          ),
        ),
        CustomTypography(
          text: "Let's save your money.",
          fontType: FontType.body2Light,
        ),
      ],
    );
  }
}
