import 'package:finpal/app/app.dart';

Widget buildExpenses(
  BuildContext context,
  WidgetRef ref,
  List<PaymentModel> transactions,
  OptionServices? options, {
  bool enableSwipe = false,
}) {
  return ListView.builder(
    itemCount: transactions.length,
    shrinkWrap: true,
    padding: EdgeInsets.zero,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder:
        (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: buildExpenseTile(
            context,
            ref,
            transactions[index],
            options,
            enableSwipe: enableSwipe,
          ),
        ),
  );
}

Future<void> showEditPaymentSheet(
  BuildContext context,
  WidgetRef ref,
  PaymentModel payment,
) async {
  final amountCtrl = TextEditingController(
    text:
        payment.amount == payment.amount.roundToDouble()
            ? payment.amount.toStringAsFixed(0)
            : payment.amount.toString(),
  );
  final notesCtrl = TextEditingController(text: payment.notes ?? '');

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: AppConstants.sidePadding,
          right: AppConstants.sidePadding,
          bottom:
              MediaQuery.of(ctx).viewInsets.bottom + AppConstants.sidePadding,
        ),
        child: CustomContainer(
          backgroundColor: BGColors.shade500,
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTypography(
                text: "Edit transaction",
                fontType: FontType.h1Semibold,
              ),
              SizedBox(height: 16.w),
              CustomTextField(
                controller: amountCtrl,
                inputType: InputType.amount,
                hintText: "Amount",
              ),
              SizedBox(height: 12.w),
              CustomTextField(
                controller: notesCtrl,
                hintText: "Notes (optional)",
              ),
              SizedBox(height: 20.w),
              CustomButton(
                label: "Save",
                onTap: () async {
                  // final raw = amountCtrl.text.trim();
                  // final amount = double.tryParse(raw);
                  // if (amount == null || amount <= 0) return;
                  // final notes = notesCtrl.text.trim();
                  // final updated = payment.copyWith(
                  //   amount: amount,
                  //   notes: notes.isEmpty ? null : notes,
                  // );
                  // await ref
                  //     .read(transactionProvider.notifier)
                  //     .updatePayment(updated);
                  // if (ctx.mounted) ctx.pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );

  amountCtrl.dispose();
  notesCtrl.dispose();
}

Widget buildExpenseTile(
  BuildContext context,
  WidgetRef ref,
  PaymentModel payment,
  OptionServices? options, {
  bool enableSwipe = false,
}) {
  final category = options?.findById(payment.categoryId);
  final isIncome = payment.paymentType == OnboardingConstants.income;
  final amount = isIncome ? payment.amount : -payment.amount;

  final row = ClipRRect(
    borderRadius: BorderRadius.circular(16.r),
    child: Row(
      spacing: 16.w,
      children: [
        CustomContainer(
          height: 32.w,
          width: 32.w,
          padding: EdgeInsets.all(8.w),
          backgroundColor: BGColors.shade100,
          child: CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: category?.icon,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTypography(
                text: category?.name ?? "Other",
                fontType: FontType.body2Medium,
              ),
              SizedBox(height: 4.w),
              CustomTypography(
                text: payment.date,
                fontType: FontType.label1Light,
              ),
            ],
          ),
        ),
        CustomTypography(
          text: formatCurrency(amount),
          fontType: FontType.body2Semibold,
          color: isIncome ? PositiveColors.shade700 : NegativeColors.shade900,
        ),
      ],
    ).padding(
      horizontal: AppConstants.sidePadding,
      vertical: 0.5 * AppConstants.sidePadding,
    ),
  );

  if (!enableSwipe) {
    return row;
  }

  return SwipeActionRow(
    actionExtent: 72.w,
    onEdit:
        () => context.push("/add_amount", extra: ExtraModel(id: payment.id)),
    onDelete:
        () => ref.read(transactionProvider.notifier).deletePayment(payment.id),
    child: row,
  );
}
