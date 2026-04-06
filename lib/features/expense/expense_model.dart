import 'package:finpal/app/app.dart';

class AnalysisModel {
  final String? icon;
  final String title;
  final double amount;
  final Color color;
  final String? notes;

  AnalysisModel({
    this.icon,
    required this.title,
    required this.amount,
    required this.color,
    this.notes,
  });
}
