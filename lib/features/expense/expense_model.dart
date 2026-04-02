import 'package:finpal/app/app.dart';

class ExpenseModel {
  final String? icon;
  final String title;
  final double amount;
  final Color color;
  final String? notes;

  ExpenseModel({
    this.icon,
    required this.title,
    required this.amount,
    required this.color,
    this.notes,
  });
}
