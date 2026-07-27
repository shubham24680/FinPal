import 'package:finpal/app/app.dart';

Widget buildExpenseTile(
  BuildContext context,
  WidgetRef ref,
  PaymentModel payment,
  OptionServices? options, {
  bool enableSwipe = false,
}) {
  final notes = payment.notes;
  final category = options?.findById(payment.categoryId);
  final isIncome = payment.paymentType == TransactionType.income.id;
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
                text:
                    notes.isNotEmpty
                        ? payment.notes
                        : category?.name ?? "Other",
                fontType: FontType.body2Medium,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 4.w),
              CustomTypography(
                text: payment.date.formatDate(),
                fontType: FontType.label1Light,
              ),
            ],
          ),
        ),
        CustomTypography(
          text: CurrencyFormatter.format(amount),
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
