import 'package:finpal/app/app.dart';

class ExpenseConstants {
  static final List<ExpenseModel> expenses = [
    ExpenseModel(title: "Earned", amount: 40911, color: Colors.green.shade700),
    ExpenseModel(
      title: "Spent",
      amount: 40911,
      color: Colors.deepPurple.shade700,
    ),
    ExpenseModel(
      title: "Available",
      amount: 40911,
      color: Colors.blue.shade700,
    ),
  ];
}
