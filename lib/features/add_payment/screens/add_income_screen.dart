import 'package:finpal/app/app.dart';

class AddIncomeScreen extends ConsumerWidget {
  const AddIncomeScreen({super.key, this.extra});
  final ExtraModel? extra;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionProv = ref.watch(transactionProvider);
    final totalIncome = transactionProv.value?.totalIncome ?? 0;
    final optionsProv = ref.watch(optionNotifer);
    final paymentProv = paymentProvider((
      OnboardingConstants.income,
      extra?.id,
    ));
    final incomeState = ref.watch(paymentProv);
    final incomeNotifier = ref.read(paymentProv.notifier);
    final bottomPadding = 8.w + MediaQuery.of(context).viewPadding.bottom;

    ref.listen(paymentProv, (prev, next) {
      if (next.isSaved && !(prev?.isSaved ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: CustomTypography(
              text: 'Income saved!',
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
                buildBalance(balance: totalIncome),
                SizedBox(height: 16.w),
                buildAmountCard(
                  context,
                  controller: incomeState.amountController,
                  title: "Enter Earned Amount",
                  color: PrimaryColors.shade500,
                  date: incomeState.date,
                  onDateSelected: (date) => incomeNotifier.setDate(date),
                  onChanged: (value) => incomeNotifier.checkCondition(value),
                ),
                SizedBox(height: 16.w),
                buildCategoryTile(
                  context,
                  "Category",
                  optionsProv.value?.incomeCategories ?? [],
                  category: incomeState.category,
                  onSelected:
                      (category) => incomeNotifier.setCategory(category),
                ),
                SizedBox(height: 8.w),
                buildCategoryTile(
                  context,
                  "Payment Method",
                  optionsProv.value?.paymentMethods ?? [],
                  category: incomeState.paymentMethod,
                  onSelected:
                      (paymentMethod) =>
                          incomeNotifier.setPaymentMethod(paymentMethod),
                ),
                SizedBox(height: 16.w),
                addNotes(incomeState.notesController),
              ],
            ),
          ),
        ),
        CustomButton(
          buttonState:
              incomeState.isFilled
                  ? (incomeState.isSaving
                      ? ButtonState.loading
                      : ButtonState.enabled)
                  : ButtonState.disabled,
          icon: AppSvgs.addPayment,
          label: incomeState.isSaving ? "Saving..." : "Add Income",
          margin: EdgeInsets.only(
            top: 8.w,
            left: AppConstants.sidePadding,
            right: AppConstants.sidePadding,
            bottom: bottomPadding,
          ),
          onTap: () => incomeNotifier.addAmount(),
        ),
      ],
    );
  }
}
