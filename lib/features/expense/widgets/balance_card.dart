import 'package:finpal/app/app.dart';

Widget balanceCard(List<AnalysisModel> analysis) {
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
            Expanded(
              child: SizedBox(
                width: 50.w,
                height: 50.w,
                child: FinancePieChart(analysis: analysis),
              ),
            ),
            SizedBox(width: 24.w),
            Expanded(
              flex: 2,
              child: GridView.builder(
                itemCount: analysis.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.8,
                  crossAxisSpacing: 8.w,
                ),
                itemBuilder: (context, index) {
                  final expense = analysis[index];
                  return buildTile(expense);
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildTile(AnalysisModel expense) {
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
            fontType: FontType.label1SemiBold,
            color: Colors.white,
          ),
          CustomTypography(
            text: CurrencyFormatter.format(expense.amount),
            fontType: FontType.label1Regular,
            color: Colors.white,
          ),
        ],
      ),
    ],
  );
}

class FinancePieChart extends StatelessWidget {
  final List<AnalysisModel> analysis;

  const FinancePieChart({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    final allZero = analysis.every((element) => element.amount <= 0);

    return PieChart(
      PieChartData(
        sectionsSpace: 1,
        centerSpaceRadius: 45,
        sections:
            allZero
                ? [
                  PieChartSectionData(
                    color: BGColors.shade100,
                    value: 100,
                    radius: 10,
                    showTitle: false,
                  ),
                ]
                : analysis.map((element) {
                  final amount =
                      element.amount < 0 ? element.amount * -1 : element.amount;
                  return PieChartSectionData(
                    color: element.color,
                    value: amount,
                    radius: 10,
                    showTitle: false,
                  );
                }).toList(),
      ),
    );
  }
}
