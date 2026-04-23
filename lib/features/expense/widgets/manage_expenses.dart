import 'dart:math';

import 'package:finpal/app/app.dart';

Widget manageExpenses(WidgetRef ref, List<PaymentModel> expense) {
  if (expense.isEmpty) {
    return const SizedBox.shrink();
  }
  final options = ref.watch(optionNotifer).value;

  return CustomContainer(
    backgroundColor: BGColors.shade500,
    padding: EdgeInsets.zero,
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
        ).padding(horizontal: AppConstants.sidePadding, top: 16.w),
        SizedBox(height: 12.w),
        ListView.builder(
          itemCount: min(expense.length, 5),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder:
              (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: buildExpenseTile(
                  context,
                  ref,
                  expense[index],
                  options,
                  enableSwipe: true,
                ),
              ),
        ),
      ],
    ),
  );
}
