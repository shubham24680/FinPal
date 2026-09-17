import 'dart:io';

import 'package:finpal/core/utils/image_storage.dart';
import 'package:finpal/features/transaction/data/services/transaction_service.dart';
import 'package:finpal/features/transaction/data/transaction_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../helpers/fake_path_provider.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/hive_test_setup.dart';
import 'package:finpal/features/transaction/data/models/payment_model.dart';

void main() {
  late Box<PaymentModel> box;
  late TransactionService service;
  late Directory documents;

  setUpAll(() async {
    await HiveTestSetup.ensureInitialized();
  });

  setUp(() async {
    documents = await Directory.systemTemp.createTemp('finpal_tx_docs_');
    PathProviderPlatform.instance = FakePathProvider(documents.path);
    box = await HiveTestSetup.openBox<PaymentModel>('payments');
    service = TransactionService(box);
  });

  tearDown(() async {
    await HiveTestSetup.closeBox(box);
    if (documents.existsSync()) await documents.delete(recursive: true);
  });

  tearDownAll(HiveTestSetup.disposeAll);

  group('TransactionService CRUD — success', () {
    test('save stores a payment and updates totals', () async {
      await service.save(
        makePayment(
          id: 'p1',
          type: TransactionType.income.id,
          amount: 1000,
        ),
      );

      expect(service.payments, hasLength(1));
      expect(service.getPayment('p1')?.amount, 1000);
      expect(service.totalIncome, 1000);
      expect(service.totalExpense, 0);
      expect(service.availableBalance, 1000);
    });

    test('saveAll writes multiple payments; empty list is a no-op', () async {
      await service.saveAll([]);
      expect(service.payments, isEmpty);

      await service.saveAll([
        makePayment(id: 'a', type: TransactionType.income.id, amount: 200),
        makePayment(id: 'b', type: TransactionType.expense.id, amount: 50),
      ]);

      expect(service.payments, hasLength(2));
      expect(service.availableBalance, 150);
    });

    test('delete removes payment and discards owned receipt', () async {
      final receipt = File('${documents.path}/cache_receipt.jpg');
      await receipt.parent.create(recursive: true);
      // Put a temp file then persist into managed folder.
      final cacheDir = await Directory.systemTemp.createTemp('finpal_cache_');
      final picked = File('${cacheDir.path}/receipt.jpg');
      await picked.writeAsBytes(List.filled(32, 1));
      final stored = await ImageStorage.persist(picked.path);

      await service.save(
        makePayment(id: 'p1', amount: 40, receiptPath: stored ?? ''),
      );
      await service.delete('p1');

      expect(service.payments, isEmpty);
      if (stored != null) {
        expect(File(stored).existsSync(), isFalse);
      }
      await cacheDir.delete(recursive: true);
    });

    test('clearData wipes payments and receipts', () async {
      await service.save(
        makePayment(
          id: 'i1',
          type: TransactionType.income.id,
          amount: 500,
        ),
      );
      await service.clearData();

      expect(service.payments, isEmpty);
      expect(service.totalIncome, 0);
      expect(service.availableBalance, 0);
    });
  });

  group('TransactionService queries', () {
    setUp(() async {
      await service.saveAll([
        makePayment(
          id: 'income_old',
          type: TransactionType.income.id,
          amount: 5000,
          date: DateTime(2026, 1, 1),
          categoryId: 'cat_salary',
        ),
        makePayment(
          id: 'expense_food',
          amount: 500,
          date: DateTime(2026, 2, 10, 9),
          categoryId: 'cat_food',
          paymentMethodId: 'method_cash',
          createdAt: DateTime(2026, 2, 10, 9),
        ),
        makePayment(
          id: 'expense_travel',
          amount: 1200,
          date: DateTime(2026, 2, 10, 18),
          categoryId: 'cat_travel',
          paymentMethodId: 'method_upi',
          createdAt: DateTime(2026, 2, 10, 18),
        ),
        makePayment(
          id: 'expense_march',
          amount: 300,
          date: DateTime(2026, 3, 5),
          categoryId: 'cat_food',
        ),
      ]);
    });

    test('incomeTransactions / expenseTransactions filter by type', () {
      expect(service.incomeTransactions, hasLength(1));
      expect(service.expenseTransactions, hasLength(3));
    });

    test('getRecentTransactions returns newest first without mutating cache', () {
      final before = service.payments.map((p) => p.id).toList();
      final recent = service.getRecentTransactions(limit: 2);
      final after = service.payments.map((p) => p.id).toList();

      expect(recent.first.id, 'expense_march');
      expect(recent, hasLength(2));
      expect(after, before);
    });

    test('getMonthlyTransactions groups by day descending', () {
      final groups = service.getMonthlyTransactions(DateTime(2026, 2));
      expect(groups, hasLength(1));
      expect(groups.first, hasLength(2));
      // Newer createdAt first within the day.
      expect(groups.first.first.id, 'expense_travel');
    });

    test('getTransactionsByDate returns same-day payments', () {
      final day = service.getTransactionsByDate(DateTime(2026, 2, 10));
      expect(day, hasLength(2));
    });

    test('filterTransactions keeps only selected type; null keeps all', () {
      final month = service.getMonthlyTransactions(DateTime(2026, 2));
      expect(service.filterTransactions(month, null), month);

      final expenses = service.filterTransactions(
        month,
        TransactionType.expense,
      );
      expect(expenses.expand((e) => e), hasLength(2));

      final incomes = service.filterTransactions(
        month,
        TransactionType.income,
      );
      expect(incomes, isEmpty);
    });

    test('transactionByCategory and transactionByCategories', () {
      final food = makeOption(id: 'cat_food', name: 'Food');
      final travel = makeOption(id: 'cat_travel', name: 'Travel');

      expect(service.transactionByCategory(food), hasLength(2));

      final rows = service.transactionByCategories([food, travel]);
      expect(rows.first.payments.length, greaterThanOrEqualTo(rows.last.payments.length));
    });

    test('paymentsInRange / totals exclude out-of-range', () {
      final start = DateTime(2026, 2, 1);
      final end = DateTime(2026, 2, 28, 23, 59, 59);
      final inRange = service.paymentsInRange(start, end);

      expect(inRange, hasLength(2));
      expect(service.totalIncomeInRange(start, end), 0);
      expect(service.totalExpenseInRange(start, end), 1700);
    });

    test('expensesByCategoryInRange sorts by amount desc', () {
      final rows = service.expensesByCategoryInRange(
        start: DateTime(2026, 2, 1),
        end: DateTime(2026, 2, 28, 23, 59, 59),
        options: sampleExpenseCategories(),
      );

      expect(rows.first.category.id, 'cat_travel');
      expect(rows.first.amount, 1200);
    });

    test('expensesByMethodInRange groups payment methods', () {
      final rows = service.expensesByMethodInRange(
        start: DateTime(2026, 2, 1),
        end: DateTime(2026, 2, 28, 23, 59, 59),
        methods: samplePaymentMethods(),
      );

      expect(rows, isNotEmpty);
      expect(rows.map((r) => r.amount).reduce((a, b) => a + b), 1700);
    });

    test('expenseTrendInRange fills days and months with zeros', () {
      final daily = service.expenseTrendInRange(
        start: DateTime(2026, 2, 9),
        end: DateTime(2026, 2, 11),
      );
      expect(daily, hasLength(3));
      expect(
        daily.firstWhere((e) => e.date.day == 10).amount,
        1700,
      );

      final monthly = service.expenseTrendInRange(
        start: DateTime(2026, 1, 1),
        end: DateTime(2026, 3, 31),
        byMonth: true,
      );
      expect(monthly, hasLength(3));
      expect(
        monthly.firstWhere((e) => e.date.month == 2).amount,
        1700,
      );
    });
  });

  group('TransactionService — empty / waiting baseline', () {
    test('empty box yields zero totals and empty lists', () {
      expect(service.payments, isEmpty);
      expect(service.totalIncome, 0);
      expect(service.totalExpense, 0);
      expect(service.availableBalance, 0);
      expect(service.getRecentTransactions(), isEmpty);
      expect(service.getMonthlyTransactions(DateTime(2026, 1)), isEmpty);
      expect(service.getPayment('missing'), isNull);
    });
  });
}
