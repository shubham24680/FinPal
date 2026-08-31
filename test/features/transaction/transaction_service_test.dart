import 'dart:io';

import 'package:finpal/features/transaction/data/models/payment_model.dart';
import 'package:finpal/features/transaction/data/services/transaction_service.dart';
import 'package:finpal/features/transaction/data/transaction_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;
  late Box<PaymentModel> box;
  late TransactionService service;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('finpal_transaction_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(PaymentModelAdapter());
    }
  });

  setUp(() async {
    box = await Hive.openBox<PaymentModel>(
      'payments_${DateTime.now().microsecondsSinceEpoch}',
    );
    service = TransactionService(box);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  PaymentModel payment({
    required String id,
    required String type,
    required double amount,
    required DateTime date,
  }) => PaymentModel(
    id: id,
    paymentType: type,
    amount: amount,
    date: date,
    createdAt: date,
  );

  group('TransactionService', () {
    test('save and delete update stored payments', () async {
      final item = payment(
        id: 'p1',
        type: TransactionType.income.id,
        amount: 1000,
        date: DateTime(2026, 1, 10),
      );

      await service.save(item);
      expect(service.payments, hasLength(1));
      expect(service.totalIncome, 1000);

      await service.delete('p1');
      expect(service.payments, isEmpty);
      expect(service.totalIncome, 0);
    });

    test('availableBalance reflects income minus expense', () async {
      await service.save(
        payment(
          id: 'income',
          type: TransactionType.income.id,
          amount: 5000,
          date: DateTime(2026, 1, 5),
        ),
      );
      await service.save(
        payment(
          id: 'expense',
          type: TransactionType.expense.id,
          amount: 1200,
          date: DateTime(2026, 1, 6),
        ),
      );

      expect(service.availableBalance, 3800);
    });

    test('filterTransactions returns only selected type', () async {
      await service.save(
        payment(
          id: 'income',
          type: TransactionType.income.id,
          amount: 500,
          date: DateTime(2026, 2, 1),
        ),
      );
      await service.save(
        payment(
          id: 'expense',
          type: TransactionType.expense.id,
          amount: 200,
          date: DateTime(2026, 2, 1),
        ),
      );

      final monthGroups = service.getMonthlyTransactions(DateTime(2026, 2));
      final filtered = service.filterTransactions(
        monthGroups,
        TransactionType.expense,
      );

      expect(filtered, hasLength(1));
      expect(filtered.first.single.paymentType, TransactionType.expense.id);
    });

    test('getRecentTransactions does not mutate cached payment order', () async {
      await service.save(
        payment(
          id: 'older',
          type: TransactionType.income.id,
          amount: 100,
          date: DateTime(2026, 1, 1),
        ),
      );
      await service.save(
        payment(
          id: 'newer',
          type: TransactionType.income.id,
          amount: 200,
          date: DateTime(2026, 1, 10),
        ),
      );

      final orderBefore = service.payments.map((payment) => payment.id).toList();
      final recent = service.getRecentTransactions(limit: 1);
      final orderAfter = service.payments.map((payment) => payment.id).toList();

      expect(recent.single.id, 'newer');
      expect(orderAfter, orderBefore);
    });
  });
}
