import 'package:finpal/app/app.dart';

class AddExpenseScreen extends ConsumerWidget {
  const AddExpenseScreen({super.key, this.extra});
  final ExtraModel? extra;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionProv = ref.watch(transactionProvider);
    final totalExpense = transactionProv.value?.totalExpense ?? 0;
    final optionsProv = ref.watch(optionNotifer);
    final paymentProv = paymentProvider((
      OptionsConstant.expense,
      extra?.id,
    ));
    final expenseState = ref.watch(paymentProv);
    final expenseNotifier = ref.read(paymentProv.notifier);
    final bottomPadding = 8.w + MediaQuery.of(context).viewPadding.bottom;

    ref.listen(paymentProv, (prev, next) {
      if (next.isSaved && !(prev?.isSaved ?? false)) {
        showToast(context, 'Expense saved!');
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
                addNotes(expenseState.notesController),
                SizedBox(height: 16.w),
                buildCategoryTile(
                  context,
                  "Category",
                  optionsProv.value?.expenseCategories ?? [],
                  category: expenseState.category,
                  onSelected:
                      (category) => expenseNotifier.setCategory(category),
                ),
                SizedBox(height: 8.w),
                buildCategoryTile(
                  context,
                  "Payment Method",
                  optionsProv.value?.paymentMethods ?? [],
                  category: expenseState.paymentMethod,
                  onSelected:
                      (paymentMethod) =>
                          expenseNotifier.setPaymentMethod(paymentMethod),
                ),
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
          prefixIcon: AppSvgs.money,
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
