import 'package:finpal/app/app.dart';

Widget categoriesTiles(
  List<({OptionModel category, List<PaymentModel> payments})> rows,
) {
  final itemCount = rows.length < 4 ? rows.length : 4;
  return GridView.builder(
    itemCount: itemCount,
    shrinkWrap: true,
    padding: EdgeInsets.zero,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.w,
    ),
    itemBuilder: (context, index) {
      final row = rows[index];
      return buildCategoryCard(row.category, row.payments);
    },
  );
}

Widget buildCategoryCard(
  OptionModel category,
  List<PaymentModel> categoryTrans,
) {
  final totalAmount = categoryTrans.fold<double>(0, (a, b) => a + b.amount);

  return CustomContainer(
    backgroundColor: PrimaryColors.shade100,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomContainer(
              height: 32.w,
              width: 32.w,
              padding: EdgeInsets.all(8.w),
              backgroundColor: PrimaryColors.shade50,
              child: CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: category.icon,
              ),
            ),
            const Spacer(),
            CustomContainer(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
              backgroundColor: PrimaryColors.shade50,
              child: CustomTypography(
                text: "${categoryTrans.length} items",
                fontType: FontType.label2Regular,
              ),
            ),
          ],
        ),
        const Spacer(),
        CustomTypography(text: category.name, fontType: FontType.label1Regular),
        SizedBox(height: 4.w),
        CustomTypography(
          text: formatCurrency(totalAmount),
          fontType: FontType.body1Semibold,
        ),
      ],
    ),
  );
}
