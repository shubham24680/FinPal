import 'package:finpal/app/app.dart';

class AddExpenseScreen extends ConsumerWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalExpense =
        ref.watch(transactionProvider).value?.totalExpense ?? 0;
    final expenseState = ref.watch(
      paymentProvider(OnboardingConstants.expense),
    );
    // final expenseCategories = ref.watch(expenseCategoryOptionsProvider);
    // final paymentMethods = ref.watch(paymentMethodOptionsProvider);
    final expenseNotifier = ref.read(
      paymentProvider(OnboardingConstants.expense).notifier,
    );
    final bottomPadding = 8.w + MediaQuery.of(context).viewPadding.bottom;

    ref.listen(paymentProvider(OnboardingConstants.expense), (prev, next) {
      if (next.isSaved && !(prev?.isSaved ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomTypography(
              text: 'Expense saved!',
              color: Colors.white,
              fontType: FontType.body2Regular,
            ),
          ),
        );
      }
    });

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppConstants.sidePadding),
            child: Column(
              children: [
                buildBalance(balance: totalExpense),
                SizedBox(height: 16.w),
                buildAmountCard(
                  context,
                  controller: expenseState.amountController,
                  title: "Enter Spent Amount",
                  backgroundColor: NegativeColors.shade100,
                  color: NegativeColors.shade500,
                  date: expenseState.date,
                  errorText: expenseState.overspent,
                  onDateSelected: (date) => expenseNotifier.setDate(date),
                  onChanged: (value) {
                    expenseNotifier.checkCondition(value);
                    expenseNotifier.checkOverspent(value);
                  },
                ),
                SizedBox(height: 16.w),
                // buildCategoryTile(
                //   context,
                //   "Category",
                //   expenseCategories,
                //   category: expenseState.category,
                //   onSelected:
                //       (category) => expenseNotifier.setCategory(category),
                // ),
                // SizedBox(height: 8.w),
                // buildCategoryTile(
                //   context,
                //   "Payment Method",
                //   paymentMethods,
                //   category: expenseState.paymentMethod,
                //   onSelected:
                //       (paymentMethod) =>
                //           expenseNotifier.setPaymentMethod(paymentMethod),
                // ),
                SizedBox(height: 16.w),
                addNotes(expenseState.notesController),
              ],
            ),
          ),
        ),
        CustomButton(
          buttonState:
              expenseState.isFilled
                  ? (expenseState.isSaving
                      ? ButtonState.loading
                      : ButtonState.enabled)
                  : ButtonState.disabled,
          icon: AppSvgs.money,
          label: expenseState.isSaving ? "Saving..." : "Add Expense",
          margin: EdgeInsets.only(
            top: 8.w,
            left: AppConstants.sidePadding,
            right: AppConstants.sidePadding,
            bottom: bottomPadding,
          ),
          onTap: () => expenseNotifier.addAmount(),
        ),
      ],
    );
  }
}
