import 'package:finpal/app/app.dart';

class AnalysisConstants {
  static List<AnalysisModel> analysis = [
    AnalysisModel(
      id: "earned",
      title: "Income",
      amount: 0,
      color: ColorSet.info,
    ),
    AnalysisModel(
      id: "spent",
      title: "Expense",
      amount: 0,
      color: ColorSet.warning,
    ),
    AnalysisModel(
      id: "available",
      title: "Remaining",
      amount: 0,
      color: ColorSet.primary,
    ),
  ];
}