import 'package:finpal/app/app.dart';

class TransactionModel {
  final List<PaymentModel> income;
  final List<PaymentModel> expense;

  TransactionModel({required this.income, required this.expense});

  double get totalIncome => income.fold<double>(0, (a, b) => a + b.amount);
  double get totalExpense => expense.fold<double>(0, (a, b) => a + b.amount);
  double get available => totalIncome - totalExpense;

  List<AnalysisModel> getAnalysis() {
    final isOverSpent = totalExpense > totalIncome;
    return [
      AnalysisModel(
        title: "Earned",
        amount: totalIncome,
        color: PrimaryColors.shade500,
      ),
      AnalysisModel(
        title: "Spent",
        amount: totalExpense,
        color: BGColors.shade700,
      ),
      AnalysisModel(
        title: isOverSpent ? "Over Spent" : "Available",
        amount: available,
        color: isOverSpent ? NegativeColors.shade500 : BGColors.shade500,
      ),
    ];
  }

  List<List<PaymentModel>> getMonthlyTransactions() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    final lastOfMonth = (now.compareTo(endOfMonth) > 0) ? endOfMonth : now;
    final monthlyTransactions = <List<PaymentModel>>[];

    for (int i = lastOfMonth.day; i >= startOfMonth.day; i--) {
      final currentDateTransaction = getTransactionsByDate(
        DateTime(now.year, now.month, i),
      );

      if (currentDateTransaction.isNotEmpty) {
        monthlyTransactions.add(currentDateTransaction);
      }
    }

    return monthlyTransactions;
  }

  List<PaymentModel> getTransactionsByDate(DateTime date) {
    return [...income, ...expense];
    // .where((payment) => parseDate(payment.date) == date)
    // .toList()
    // .reversed
    // .toList();
  }

  List<List<PaymentModel>> getTransactionsByCategories() {
    return OnboardingConstants.expenseCategories.map((category) {
      return expense
          .where((spent) => spent.categoryId == category.id)
          .toList(growable: false);
    }).toList();
  }
}
