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

  double get availableBalance => totalIncome - totalExpense;

  List<PaymentModel> get incomeTransactions => payments
      .where((p) => p.paymentType == TransactionType.income.id)
      .toList(growable: false);

  List<PaymentModel> get expenseTransactions => payments
      .where((p) => p.paymentType == TransactionType.expense.id)
      .toList(growable: false);

  List<PaymentModel> getRecentTransactions({int limit = 5}) {
    payments.sort((a, b) => b.date.compareTo(a.date));
    return payments.take(limit).toList(growable: false);
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

  // Filters
  List<List<PaymentModel>> filterTransactions(
    List<List<PaymentModel>> transactions,
    TransactionType? typeFilter,
  ) {
    if (typeFilter == null) return transactions;
    return transactions
        .map(
          (payments) => payments
              .where((payment) => payment.paymentType == typeFilter.id)
              .toList(growable: false),
        )
        .where((payments) => payments.isNotEmpty)
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

  List<PaymentModel> paymentsInRange(DateTime start, DateTime end) {
    return payments
        .where(
          (payment) =>
              !payment.date.isBefore(start) && !payment.date.isAfter(end),
        )
        .toList(growable: false);
  }

  double totalIncomeInRange(DateTime start, DateTime end) {
    var total = 0.0;
    for (final payment in paymentsInRange(start, end)) {
      if (payment.paymentType == TransactionType.income.id) {
        total += payment.amount;
      }
    }
    return total;
  }

  double totalExpenseInRange(DateTime start, DateTime end) {
    var total = 0.0;
    for (final payment in paymentsInRange(start, end)) {
      if (payment.paymentType == TransactionType.expense.id) {
        total += payment.amount;
      }
    }
    return total;
  }

  List<({OptionModel category, double amount, int count})>
  expensesByCategoryInRange({
    required DateTime start,
    required DateTime end,
    required List<OptionModel> options,
  }) {
    final expenses = paymentsInRange(
      start,
      end,
    ).where((p) => p.paymentType == TransactionType.expense.id);
    final byId = <String, List<PaymentModel>>{};
    for (final payment in expenses) {
      (byId[payment.categoryId] ??= []).add(payment);
    }
    final optionById = {for (final o in options) o.id: o};
    final rows = <({OptionModel category, double amount, int count})>[];
    for (final entry in byId.entries) {
      final category = optionById[entry.key] ?? OptionsConstant.otherCategory;
      final amount = entry.value.fold<double>(0, (a, b) => a + b.amount);
      rows.add((category: category, amount: amount, count: entry.value.length));
    }
    rows.sort((a, b) => b.amount.compareTo(a.amount));
    return rows;
  }

  List<({OptionModel method, double amount, int count})>
  expensesByMethodInRange({
    required DateTime start,
    required DateTime end,
    required List<OptionModel> methods,
  }) {
    final expenses = paymentsInRange(
      start,
      end,
    ).where((p) => p.paymentType == TransactionType.expense.id);
    final byId = <String, List<PaymentModel>>{};
    for (final payment in expenses) {
      (byId[payment.paymentMethodId] ??= []).add(payment);
    }
    final methodById = {for (final m in methods) m.id: m};
    final rows = <({OptionModel method, double amount, int count})>[];
    for (final entry in byId.entries) {
      final method = methodById[entry.key] ?? OptionsConstant.otherCategory;
      final amount = entry.value.fold<double>(0, (a, b) => a + b.amount);
      rows.add((method: method, amount: amount, count: entry.value.length));
    }
    rows.sort((a, b) => b.amount.compareTo(a.amount));
    return rows;
  }

  List<({DateTime date, double amount})> expenseTrendInRange({
    required DateTime start,
    required DateTime end,
    bool byMonth = false,
  }) {
    if (byMonth) {
      final byMonthMap = <DateTime, double>{};
      for (var year = start.year; year <= end.year; year++) {
        final monthStart = year == start.year ? start.month : 1;
        final monthEnd = year == end.year ? end.month : 12;
        for (var m = monthStart; m <= monthEnd; m++) {
          byMonthMap[DateTime(year, m)] = 0;
        }
      }
      for (final payment in paymentsInRange(start, end)) {
        if (payment.paymentType != TransactionType.expense.id) continue;
        final key = DateTime(payment.date.year, payment.date.month);
        byMonthMap[key] = (byMonthMap[key] ?? 0) + payment.amount;
      }
      return [
        for (final e in byMonthMap.entries) (date: e.key, amount: e.value),
      ];
    }

    final byDay = <DateTime, double>{};
    var cursor = start.startOfDay;
    final last = end.startOfDay;
    while (!cursor.isAfter(last)) {
      byDay[cursor] = 0;
      cursor = cursor.add(const Duration(days: 1));
    }
    for (final payment in paymentsInRange(start, end)) {
      if (payment.paymentType != TransactionType.expense.id) continue;
      final key = payment.date.startOfDay;
      if (byDay.containsKey(key)) {
        byDay[key] = byDay[key]! + payment.amount;
      }
    }
    return [for (final e in byDay.entries) (date: e.key, amount: e.value)];
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
