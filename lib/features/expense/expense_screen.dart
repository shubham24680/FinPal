import 'package:finpal/app/app.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.sidePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              maxLines: 1,
              overflow: TextOverflow.clip,
              text: TextSpan(
                style:
                    CustomTypography(fontType: FontType.h1Bold).getTextStyle(),
                children: [
                  TextSpan(
                    text: "Hello ",
                    style:
                        CustomTypography(
                          fontType: FontType.h1Semibold,
                        ).getTextStyle(),
                  ),
                  TextSpan(text: "Shubham!"),
                ],
              ),
            ),
            CustomTypography(
              text: "Let's save your money.",
              fontType: FontType.body2Light,
            ),
            SizedBox(height: 16.w),
            _buildBalanceCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return CustomContainer(
      backgroundColor: CardColors.shade1000,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTypography(
            text: "Analytics",
            fontType: FontType.body2Semibold,
            color: Colors.white,
          ),
          SizedBox(height: 16.w),
          Row(
            children: [
              Expanded(child: CustomImage(imageUrl: "assets/images/Group.png")),
              SizedBox(width: 24.w),
              Expanded(
                flex: 2,
                child: GridView.builder(
                  itemCount: ExpenseConstants.expenses.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.8,
                    crossAxisSpacing: 8.w,
                  ),
                  itemBuilder: (context, index) {
                    final expense = ExpenseConstants.expenses[index];
                    return _buildTile(expense);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTile(ExpenseModel expense) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8.w,
      children: [
        CustomContainer(
          height: 8.w,
          width: 8.w,
          backgroundColor: expense.color,
          borderRadius: BorderRadius.circular(1000.r),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.w,
          children: [
            CustomTypography(
              text: expense.title,
              fontType: FontType.body2Medium,
              color: Colors.white,
            ),
            CustomTypography(
              text: "\$${expense.amount.toStringAsFixed(2)}",
              fontType: FontType.labelRegular,
              color: Colors.white,
            ),
          ],
        ),
      ],
    );
  }
}
