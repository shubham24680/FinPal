import 'dart:developer';

import 'package:finpal/app/app.dart';

class TransactionService {
  final Box<PaymentModel> box;
  late HiveService<PaymentModel> _hiveService;
  List<PaymentModel> payments = [];

  TransactionService(this.box) {
    _hiveService = HiveService<PaymentModel>(box);
    payments = _hiveService.getAllData();
  }

  Future<void> save(PaymentModel payment) async {
    await _hiveService.saveData(payment.id, payment);
    payments = [...payments, payment];
    log("Payment saved: ${payment.id}", name: "TransactionService");
  }

  Future<void> saveAll(List<PaymentModel> newPayments) async {
    for (var payment in newPayments) {
      await _hiveService.saveData(payment.id, payment);
    }
    payments = [...payments, ...newPayments];
    log("Payments saved: ${newPayments.length}", name: "TransactionService");
  }

  double get totalIncome =>
      incomeTransactions.fold<double>(0, (a, b) => a + b.amount);
  double get totalExpense =>
      expenseTransactions.fold<double>(0, (a, b) => a + b.amount);
  double get available => totalIncome - totalExpense;

  List<PaymentModel> get incomeTransactions =>
      payments
          .where((p) => p.paymentType == OnboardingConstants.income)
          .toList();

  List<PaymentModel> get expenseTransactions =>
      payments
          .where((p) => p.paymentType == OnboardingConstants.expense)
          .toList();

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
    List<List<PaymentModel>> montlyTransactions = [];

    for (int i = lastOfMonth.day; i >= startOfMonth.day; i--) {
      final currentDateTransaction = getTransactionsByDate(
        DateTime(now.year, now.month, i),
      );

      if (currentDateTransaction.isNotEmpty) {
        montlyTransactions.add(currentDateTransaction);
      }
    }

    return montlyTransactions;
  }

  List<PaymentModel> getTransactionsByDate(DateTime date) {
    return payments
        .where((payment) => payment.date == formatDate(date))
        .toList()
        .reversed
        .toList();
  }

  List<({OptionModel category, List<PaymentModel> payments})>
  transactionByCategories(List<OptionModel> options) {
    final rows =
        options
            .map(
              (category) => (
                category: category,
                payments: transactionByCategory(category),
              ),
            )
            .toList();
    rows.sort((a, b) => b.payments.length.compareTo(a.payments.length));
    return rows;
  }

  List<PaymentModel> transactionByCategory(OptionModel options) {
    return payments
        .where((payment) => payment.categoryId == options.id)
        .toList();
  }
}
