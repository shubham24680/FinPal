import 'package:finpal/app/app.dart';

class AddIncomeScreen extends ConsumerWidget {
  const AddIncomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalIncome = ref.watch(transactionProvider).value?.totalIncome ?? 0;
    final incomeState = ref.watch(paymentProvider(OnboardingConstants.income));
    // final incomeCategories = ref.watch(incomeCategoryOptionsProvider);
    // final paymentMethods = ref.watch(paymentMethodOptionsProvider);
    final incomeNotifier = ref.read(
      paymentProvider(OnboardingConstants.income).notifier,
    );
    final bottomPadding = 8.w + MediaQuery.of(context).viewPadding.bottom;

    ref.listen(paymentProvider(OnboardingConstants.income), (prev, next) {
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
                // buildCategoryTile(
                //   context,
                //   "Category",
                //   incomeCategories,
                //   category: incomeState.category,
                //   onSelected:
                //       (category) => incomeNotifier.setCategory(category),
                // ),
                // SizedBox(height: 8.w),
                // buildCategoryTile(
                //   context,
                //   "Payment Method",
                //   paymentMethods,
                //   category: incomeState.paymentMethod,
                //   onSelected:
                //       (paymentMethod) =>
                //           incomeNotifier.setPaymentMethod(paymentMethod),
                // ),
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
