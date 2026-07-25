import 'dart:developer';

import 'package:finpal/app/app.dart';

class TransactionService {
  final HiveService<PaymentModel> _hiveService;
  List<PaymentModel>? _cache;
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;

  TransactionService(Box<PaymentModel> box)
    : _hiveService = HiveService<PaymentModel>(box);

  // CRUD Operations
  Future<void> save(PaymentModel payment) async {
    await _hiveService.saveData(payment.id, payment);
    clearCache();
    log(
      "Payment saved: ${payment.id} (total=${payments.length})",
      name: "TransactionService",
    );
  }

  Future<void> saveAll(List<PaymentModel> newPayments) async {
    if (newPayments.isEmpty) return;
    await _hiveService.saveAllData({
      for (final payment in newPayments) payment.id: payment,
    });
    clearCache();
    log("Payments saved: ${newPayments.length}", name: "TransactionService");
  }

  Future<void> delete(String id) async {
    await _hiveService.clearData(id);
    clearCache();
    log("Payment deleted: $id", name: "TransactionService");
  }

  void clearCache() {
    _cache = null;
    _totalIncome = 0.0;
    _totalExpense = 0.0;
  }

  // Getters
  List<PaymentModel> get payments => _cache ??= _hiveService.getAllData();
  PaymentModel? getPayment(String id) => _hiveService.getData(id);
  double get totalIncome {
    _ensureTotals();
    return _totalIncome;
  }

  double get totalExpense {
    _ensureTotals();
    return _totalExpense;
  }

  double get available => totalIncome - totalExpense;

  List<PaymentModel> get incomeTransactions => payments
      .where((p) => p.paymentType == TransactionType.income.id)
      .toList(growable: false);

  List<PaymentModel> get expenseTransactions => payments
      .where((p) => p.paymentType == TransactionType.expense.id)
      .toList(growable: false);

  // Aggregations & filters
  List<AnalysisModel> getAnalysis() {
    final income = totalIncome;
    final expense = totalExpense;
    final balance = income - expense;
    final isOverSpent = expense > income;

    return [
      AnalysisModel(
        title: "Earned",
        amount: income,
        color: PrimaryColors.shade500,
      ),
      AnalysisModel(title: "Spent", amount: expense, color: BGColors.shade700),
      AnalysisModel(
        title: isOverSpent ? "Over Spent" : "Available",
        amount: balance,
        color: isOverSpent ? NegativeColors.shade500 : BGColors.shade500,
      ),
    ];
  }

  // Todo: Optimize this method.
  List<List<PaymentModel>> getMonthlyTransactions(DateTime month) {
    final byDay = <DateTime, List<PaymentModel>>{};

    for (final payment in payments) {
      if (!payment.date.isSameMonthAs(month)) continue;
      final day = payment.date.startOfDay;
      (byDay[day] ??= []).add(payment);
    }

    final days = byDay.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final day in days)
        byDay[day]!..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
    ];
  }

  List<PaymentModel> getTransactionsByDate(DateTime date) {
    return payments
        .where((payment) => payment.date.isSameDayAs(date))
        .toList(growable: false)
        .reversed
        .toList(growable: false);
  }

  List<({OptionModel category, List<PaymentModel> payments})>
  transactionByCategories(List<OptionModel> options) {
    final paymentsByCategory = <String, List<PaymentModel>>{};
    for (final payment in payments) {
      (paymentsByCategory[payment.categoryId] ??= []).add(payment);
    }

    final rows = [
      for (final category in options)
        (
          category: category,
          payments: paymentsByCategory[category.id] ?? const <PaymentModel>[],
        ),
    ];
    rows.sort((a, b) => b.payments.length.compareTo(a.payments.length));
    return rows;
  }

  List<PaymentModel> transactionByCategory(OptionModel option) {
    return payments
        .where((payment) => payment.categoryId == option.id)
        .toList(growable: false);
  }

  void _ensureTotals() {
    var income = 0.0;
    var expense = 0.0;
    for (final payment in payments) {
      if (payment.paymentType == TransactionType.income.id) {
        income += payment.amount;
      } else if (payment.paymentType == TransactionType.expense.id) {
        expense += payment.amount;
      }
    }
    _totalIncome = income;
    _totalExpense = expense;
  }
}
