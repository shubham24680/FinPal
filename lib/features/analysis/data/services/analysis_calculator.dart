import 'package:finpal/app/app.dart';
import 'package:intl/intl.dart';

class AnalysisCalculator {
  AnalysisCalculator._();

  static List<AnalysisModel> getCategories(
    List<PaymentModel> payments,
    List<OptionModel> allCategories, {
    int limit = 4,
  }) {
    final expenseId = TransactionType.expense.id;
    final categoryType = OptionType.expense.id;
    Map<String, double> amountByCategory = {};
    payments.where((payment) => payment.paymentType == expenseId).forEach((
      element,
    ) {
      amountByCategory[element.categoryId] =
          (amountByCategory[element.categoryId] ?? 0) + element.amount;
    });
    final categories = allCategories
      .where((category) => category.type == categoryType)
      .map(
        (category) => AnalysisModel(
          id: category.id,
          title: category.name,
          amount: amountByCategory[category.id] ?? 0,
          color: category.color.colorSet,
          icon: category.icon,
        ),
      )
      .toList(growable: false)..sort((a, b) => b.amount.compareTo(a.amount));
    return categories.take(limit).toList(growable: false);
  }

  static PeriodAnalysis compute({
    AnalysisPeriod period = AnalysisPeriod.thisMonth,
    List<PaymentModel> payments = const [],
    List<OptionModel> expenseCategories = const [],
    List<OptionModel> paymentMethods = const [],
    CurrencyContants currency = CurrencyContants.rupee,
    OptionModel? fallbackCategory,
    OptionModel? fallbackMethod,
  }) {
    final range = period.range;
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
    final categories = categoryBreakdown(expenses, expenseCategories, expense);
    final methods = methodBreakdown(expenses, paymentMethods, expense);

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
                title: isOverSpent ? 'Over Spent' : 'Available',
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
    double totalAmount,
  ) {
    final byId = <String, List<PaymentModel>>{};
    for (final p in payments) {
      (byId[p.categoryId] ??= []).add(p);
    }

    return breakdownPayments(byId, categories, totalAmount);
  }

  static List<AnalysisModel> methodBreakdown(
    List<PaymentModel> payments,
    List<OptionModel> category,
    double total,
  ) {
    final byId = <String, List<PaymentModel>>{};
    for (final p in payments) {
      (byId[p.paymentMethodId] ??= []).add(p);
    }

    return breakdownPayments(byId, category, total);
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
    double totalAmount,
  ) {
    final rows = <AnalysisModel>[];

    for (final entry in byId.entries) {
      final category = categories.firstWhere(
        (c) => c.id == entry.key,
        orElse: () => OptionsConstant.otherCategory,
      );
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
}
