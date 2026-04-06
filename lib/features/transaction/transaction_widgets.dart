import 'package:finpal/app/app.dart';

Widget buildExpenses(BuildContext context, List<PaymentModel> transactions) {
  return ListView.separated(
    itemCount: transactions.length,
    shrinkWrap: true,
    padding: EdgeInsets.zero,
    physics: const NeverScrollableScrollPhysics(),
    itemBuilder:
        (context, index) => buildExpenseTile(context, transactions[index]),
    separatorBuilder: (context, index) => SizedBox(height: 12.w),
  );
}

final List<OptionModel> options = [
  OptionModel(name: "Edit", icon: AppSvgs.edit),
  OptionModel(name: "Delete", icon: AppSvgs.delete),
];

Widget buildExpenseTile(BuildContext context, PaymentModel payment) {
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
          imageUrl:
              payment.paymentType == PaymentConstants.income
                  ? AppSvgs.income
                  : AppSvgs.expense,
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTypography(
              text: payment.category.name,
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
        text: formatCurrency(payment.amount),
        fontType: FontType.body2Semibold,
      ),
    ],
  ).onTap(event: () => customBottomSheet(context, "Options", options: options));
}
