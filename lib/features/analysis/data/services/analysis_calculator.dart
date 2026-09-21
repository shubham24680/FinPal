import 'package:finpal/app/app.dart';
import 'package:intl/intl.dart';

class AnalysisCalculator {
  AnalysisCalculator._();

  static List<AnalysisModel> getCategories(
    List<PaymentModel> payments,
    List<OptionModel> allCategories, {
    int? limit = 4,
    bool onlyWithSpend = false,
    DateTime? month,
  }) {
    final expenseId = TransactionType.expense.id;
    final categoryType = OptionType.expense.id;
    final other = OptionsConstant.otherCategory;
    final knownIds = {
      for (final category in allCategories)
        if (category.type == categoryType) category.id,
    };
    final amountByCategory = <String, double>{};
    final countByCategory = <String, int>{};

    for (final payment in payments) {
      if (payment.paymentType != expenseId) continue;
      if (month != null && !payment.date.isSameMonthAs(month)) continue;
      final categoryId = _resolvedOptionId(payment.categoryId, knownIds);
      amountByCategory[categoryId] =
          (amountByCategory[categoryId] ?? 0) + payment.amount;
      countByCategory[categoryId] = (countByCategory[categoryId] ?? 0) + 1;
    }

    var categories =
        allCategories
            .where((category) => category.type == categoryType)
            .map(
              (category) => AnalysisModel(
                id: category.id,
                title: category.name,
                amount: amountByCategory[category.id] ?? 0,
                count: countByCategory[category.id] ?? 0,
                color: category.color.colorSet,
                icon: category.icon,
              ),
            )
            .toList();

    final otherAmount = amountByCategory[other.id] ?? 0;
    final otherCount = countByCategory[other.id] ?? 0;
    if (otherAmount > 0 || otherCount > 0) {
      categories.add(
        AnalysisModel(
          id: other.id,
          title: other.name,
          amount: otherAmount,
          count: otherCount,
          color: other.color.colorSet,
          icon: other.icon,
        ),
      );
    }

    if (onlyWithSpend) {
      categories = categories.where((c) => c.amount > 0).toList();
    }
    categories.sort((a, b) => b.amount.compareTo(a.amount));
    if (limit == null) return List.unmodifiable(categories);
    return categories.take(limit).toList(growable: false);
  }

  static CategoryMonthAnalysis categoryMonthAnalysis({
    required String categoryId,
    required DateTime month,
    required List<PaymentModel> payments,
    required OptionModel category,
    List<OptionModel> paymentMethods = const [],
    List<OptionModel> knownCategories = const [],
  }) {
    final range = DateTimeRange(
      start: month.startOfMonth,
      end: month.endOfMonth,
    );
    final monthPayments = payments
        .where((p) => inRange(p.date, range))
        .toList(growable: false);
    final monthExpenses = monthPayments
        .where((p) => p.paymentType == TransactionType.expense.id)
        .toList(growable: false);
    final monthExpenseTotal = sumByType(monthPayments, TransactionType.expense);
    final knownIds = {for (final c in knownCategories) c.id};
    final categoryPayments = monthExpenses
        .where(
          (p) => _matchesResolvedOption(
            paymentOptionId: p.categoryId,
            targetId: categoryId,
            knownIds: knownIds,
          ),
        )
        .toList(growable: false);
    final amount = categoryPayments.fold<double>(0, (a, b) => a + b.amount);
    final count = categoryPayments.length;
    final percentage =
        monthExpenseTotal > 0 ? (amount / monthExpenseTotal) * 100 : 0.0;
    return CategoryMonthAnalysis(
      summary: AnalysisModel(
        id: category.id,
        title: category.name,
        amount: amount,
        count: count,
        percentage: percentage,
        color: category.color.colorSet,
        icon: category.icon,
      ),
      monthExpenseTotal: monthExpenseTotal,
      trend: getTrend(categoryPayments, AnalysisPeriod.thisMonth, range),
      methods: methodBreakdown(categoryPayments, paymentMethods, amount),
      range: range,
    );
  }

  static PeriodAnalysis compute({
    AnalysisPeriod period = AnalysisPeriod.thisMonth,
    List<PaymentModel> payments = const [],
    List<OptionModel> expenseCategories = const [],
    List<OptionModel> paymentMethods = const [],
    CurrencyContants currency = CurrencyContants.rupee,
    OptionModel? fallbackCategory,
    OptionModel? fallbackMethod,
    DateTime? month,
  }) {
    final now = DateTime.now();
    // final range = period.range;
    final range = DateTimeRange(start: (month ?? now).startOfMonth, end: (month ?? now).endOfMonth);
    final inPeriodPayments = payments
        .where((p) => inRange(p.date, range))
        .toList(growable: false);

    //current period income, expense, net
    final income = sumByType(inPeriodPayments, TransactionType.income);
    final expense = sumByType(inPeriodPayments, TransactionType.expense);
    final expenses = inPeriodPayments
        .where((p) => p.paymentType == TransactionType.expense.id)
        .toList(growable: false);
    final incomes = inPeriodPayments
        .where((p) => p.paymentType == TransactionType.income.id)
        .toList(growable: false);
    final available = income - expense;

    final analysisPie = getAnalysis(income, expense, available);
    final expenseTrend = getTrend(expenses, period, range);
    final incomeTrend = getTrend(incomes, period, range);
    final categories = categoryBreakdown(
      expenses,
      expenseCategories,
      expense,
      fallback: fallbackCategory ?? OptionsConstant.otherCategory,
    );
    final methods = methodBreakdown(
      expenses,
      paymentMethods,
      expense,
      fallback: fallbackMethod ?? OptionsConstant.otherCategory,
    );

    return PeriodAnalysis(
      period: period,
      income: income,
      expense: expense,
      available: available,
      analysisPie: analysisPie,
      expenseTrend: expenseTrend,
      incomeTrend: incomeTrend,
      categories: categories,
      methods: methods,
    );
  }

  static List<AnalysisModel> getAnalysis(
    double? income,
    double? expense,
    double? available,
  ) {
    final isOverSpent = (expense ?? 0) > (income ?? 0);

    return AnalysisConstants.analysis
        .map((e) {
          switch (e.id) {
            case "earned":
              return e.copyWith(amount: income);
            case "spent":
              return e.copyWith(amount: expense);
            case "available":
              return e.copyWith(
                title: isOverSpent ? 'Overspent' : 'Remaining',
                color: isOverSpent ? ColorSet.error : ColorSet.primary,
                amount: available?.abs(),
              );
            default:
              return e;
          }
        })
        .toList(growable: false);
  }

  static List<AnalysisModel> getTrend(
    List<PaymentModel> payments,
    AnalysisPeriod period,
    DateTimeRange range,
  ) {
    if (period == AnalysisPeriod.thisYear) {
      final byMonth = <DateTime, double>{};
      for (var m = 1; m <= 12; m++) {
        byMonth[DateTime(range.start.year, m)] = 0;
      }
      for (final p in payments) {
        final key = DateTime(p.date.year, p.date.month);
        byMonth[key] = (byMonth[key] ?? 0) + p.amount;
      }
      return [
        for (final entry in byMonth.entries)
          AnalysisModel(
            id: entry.key.month.toString(),
            title: entry.key.formatDate(type: DateFormatType.shortMonth),
            amount: entry.value,
          ),
      ];
    }

    final days = <DateTime, double>{};
    var cursor = range.start.startOfDay;
    final end = range.end.startOfDay;
    while (!cursor.isAfter(end)) {
      days[cursor] = 0;
      cursor = cursor.add(const Duration(days: 1));
    }
    for (final p in payments) {
      final key = p.date.startOfDay;
      if (days.containsKey(key)) {
        days[key] = days[key]! + p.amount;
      }
    }

    if (period == AnalysisPeriod.thisWeek) {
      return [
        for (final entry in days.entries)
          AnalysisModel(
            id: entry.key.day.toString(),
            title: entry.key.formatDate(type: DateFormatType.shortDay),
            amount: entry.value,
          ),
      ];
    }

    return [
      for (final entry in days.entries)
        AnalysisModel(
          id: entry.key.day.toString(),
          title: DateFormat.d().format(entry.key),
          amount: entry.value,
        ),
    ];
  }

  static List<AnalysisModel> categoryBreakdown(
    List<PaymentModel> payments,
    List<OptionModel> categories,
    double totalAmount, {
    OptionModel? fallback,
  }) {
    final knownIds = {for (final c in categories) c.id};
    final byId = <String, List<PaymentModel>>{};
    for (final p in payments) {
      final id = _resolvedOptionId(p.categoryId, knownIds);
      (byId[id] ??= []).add(p);
    }

    return breakdownPayments(
      byId,
      categories,
      totalAmount,
      fallback: fallback ?? OptionsConstant.otherCategory,
    );
  }

  static List<AnalysisModel> methodBreakdown(
    List<PaymentModel> payments,
    List<OptionModel> methods,
    double total, {
    OptionModel? fallback,
  }) {
    final knownIds = {for (final m in methods) m.id};
    final byId = <String, List<PaymentModel>>{};
    for (final p in payments) {
      final id = _resolvedOptionId(p.paymentMethodId, knownIds);
      (byId[id] ??= []).add(p);
    }

    return breakdownPayments(
      byId,
      methods,
      total,
      fallback: fallback ?? OptionsConstant.otherCategory,
    );
  }

  static bool inRange(DateTime date, DateTimeRange range) {
    return !date.isBefore(range.start) && !date.isAfter(range.end);
  }

  static double sumByType(
    Iterable<PaymentModel> payments,
    TransactionType type,
  ) {
    var total = 0.0;
    for (final p in payments) {
      if (p.paymentType == type.id) total += p.amount;
    }
    return total;
  }

  static List<AnalysisModel> breakdownPayments(
    Map<String, List<PaymentModel>> byId,
    List<OptionModel> categories,
    double totalAmount, {
    OptionModel? fallback,
  }) {
    final fallbackOption = fallback ?? OptionsConstant.otherCategory;
    final optionsById = {for (final c in categories) c.id: c};
    final rows = <AnalysisModel>[];

    for (final entry in byId.entries) {
      final category = optionsById[entry.key] ?? fallbackOption;
      final amount = entry.value.fold<double>(0, (a, b) => a + b.amount);
      rows.add(
        AnalysisModel(
          id: category.id,
          title: category.name,
          icon: category.icon,
          color: category.color.colorSet,
          amount: amount,
          count: entry.value.length,
          percentage: totalAmount > 0 ? (amount / totalAmount) * 100 : 0,
        ),
      );
    }

    rows.sort((a, b) => b.amount.compareTo(a.amount));
    return rows;
  }

  /// Maps empty / unknown option ids onto [OptionsConstant.otherCategory].
  static String _resolvedOptionId(String optionId, Set<String> knownIds) {
    if (optionId.isEmpty) return OptionsConstant.otherCategory.id;
    if (knownIds.isEmpty || knownIds.contains(optionId)) return optionId;
    return OptionsConstant.otherCategory.id;
  }

  static bool matchesCategory({
    required String paymentCategoryId,
    required String categoryId,
    required Iterable<OptionModel> knownCategories,
  }) {
    final knownIds = {for (final c in knownCategories) c.id};
    return _matchesResolvedOption(
      paymentOptionId: paymentCategoryId,
      targetId: categoryId,
      knownIds: knownIds,
    );
  }

  static bool _matchesResolvedOption({
    required String paymentOptionId,
    required String targetId,
    required Set<String> knownIds,
  }) {
    return _resolvedOptionId(paymentOptionId, knownIds) == targetId;
  }
}
