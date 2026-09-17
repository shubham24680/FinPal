import 'package:finpal/app/app.dart';

class AnalysisModel {
  final String id;
  final String title;
  final double amount;
  final int count;
  final double percentage;
  final ColorSet color;
  final String? icon;

  AnalysisModel({
    required this.id,
    required this.title,
    this.amount = 0,
    this.count = 0,
    this.percentage = 0,
    this.color = ColorSet.primary,
    this.icon,
  });

  AnalysisModel copyWith({
    String? id,
    String? title,
    double? amount,
    int? count,
    double? percentage,
    ColorSet? color,
    String? icon,
  }) {
    return AnalysisModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      count: count ?? this.count,
      percentage: percentage ?? this.percentage,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }
}

class PeriodAnalysis {
  final AnalysisPeriod period;
  final double income;
  final double expense;
  final double available;
  final List<AnalysisModel> analysisPie;
  final List<AnalysisModel> expenseTrend;
  final List<AnalysisModel> incomeTrend;
  final List<AnalysisModel> categories;
  final List<AnalysisModel> methods;

  const PeriodAnalysis({
     this.period = AnalysisPeriod.thisMonth,
     this.income = 0,
     this.expense = 0,
     this.available = 0,
    this.analysisPie = const [],
     this.expenseTrend = const [],
     this.incomeTrend = const [],
     this.categories = const [],
     this.methods = const [],
  });
}

class CategoryMonthAnalysis {
  final AnalysisModel summary;
  final double monthExpenseTotal;
  final List<AnalysisModel> trend;
  final List<AnalysisModel> methods;
  final DateTimeRange range;
  const CategoryMonthAnalysis({
    required this.summary,
    this.monthExpenseTotal = 0,
    this.trend = const [],
    this.methods = const [],
    required this.range,
  });
}
