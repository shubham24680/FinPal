import 'dart:math';

import 'package:finpal/app/app.dart';

Widget manageExpenses(WidgetRef ref, List<PaymentModel> expense) {
  if (expense.isEmpty) {
    return const SizedBox.shrink();
  }

  return CustomContainer(
    backgroundColor: BGColors.shade500,
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTypography(
              text: "Manage Expenses",
              fontType: FontType.body2Semibold,
            ),
            CustomTypography(
              text: "View All",
              fontType: FontType.label1Regular,
              color: TextColors.shade300,
            ).onTap(event: () => ref.read(navProvider.notifier).state = 1),
          ],
        ),
        SizedBox(height: 12.w),
        ListView.separated(
          itemCount: min(expense.length, 5),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder:
              (context, index) => buildExpenseTile(context, expense[index]),
          separatorBuilder: (context, index) => SizedBox(height: 12.w),
        ),
      ],
    ),
  );
}
