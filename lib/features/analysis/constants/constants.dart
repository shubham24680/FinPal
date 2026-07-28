import 'package:finpal/app/app.dart';

class AnalysisConstants {
  static List<AnalysisModel> analysis = [
    AnalysisModel(
      id: "earned",
      title: "Earned",
      amount: 0,
      color: ColorSet.info,
    ),
    AnalysisModel(
      id: "spent",
      title: "Spent",
      amount: 0,
      color: ColorSet.accent,
    ),
    AnalysisModel(
      id: "available",
      title: "Available",
      amount: 0,
      color: ColorSet.primary,
    ),
  ];
}