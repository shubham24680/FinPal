import 'package:finpal/app/app.dart';

class AddAmountScreen extends StatelessWidget {
  const AddAmountScreen({super.key, this.extra});
  final ExtraModel? extra;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: customAppBar(
          context,
          title: "Add Payment",
          bottom: TabBar(
            indicatorColor: BGColors.shade900,
            dividerColor: BGColors.shade500,
            labelColor: BGColors.shade900,
            unselectedLabelColor: BGColors.shade700,
            labelStyle:
                CustomTypography(
                  fontType: FontType.body1Semibold,
                ).getTextStyle(),
            unselectedLabelStyle:
                CustomTypography(fontType: FontType.body2Medium).getTextStyle(),
            tabs: [Tab(text: "Income"), Tab(text: "Expense")],
          ),
        ),
        body: TabBarView(
          children: [
            AddIncomeScreen(extra: extra),
            AddExpenseScreen(extra: extra),
          ],
        ),
      ),
    ).onTap(event: () => FocusScope.of(context).unfocus());
  }
}
