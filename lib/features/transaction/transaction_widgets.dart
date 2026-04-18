import 'package:finpal/app/app.dart';

Widget buildExpenses(
  BuildContext context,
  List<PaymentModel> transactions,
  OptionServices? options,
) {
  return ListView.separated(
    itemCount: transactions.length,
    shrinkWrap: true,
    padding: EdgeInsets.zero,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder:
        (context, index) =>
            buildExpenseTile(context, transactions[index], options),
    separatorBuilder: (context, index) => SizedBox(height: 12.w),
  );
}

final List<OptionModel> options = [
  // OptionModel(name: "Edit", icon: AppSvgs.edit),
  // OptionModel(name: "Delete", icon: AppSvgs.delete),
];

Widget buildExpenseTile(
  BuildContext context,
  PaymentModel payment,
  OptionServices? options,
) {
  final category = options?.findById(payment.categoryId);
  final isIncome = payment.paymentType == OnboardingConstants.income;
  final amount = isIncome ? payment.amount : -payment.amount;

  return Row(
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
  ).onTap(
    event:
        () => customBottomSheet(context, "Options", options: options?.options),
  );
}
