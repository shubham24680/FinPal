import 'dart:developer';

import 'package:finpal/app/app.dart';

final transactionBoxProvider = Provider<Box<TransactionModel>>(
  (ref) => throw UnimplementedError(),
);

class TransactionNotifier extends AsyncNotifier<TransactionModel> {
  late HiveService<TransactionModel> _hive;
  static const _key = 'transaction';

  @override
  Future<TransactionModel> build() async {
    final box = ref.watch(transactionBoxProvider);
    _hive = HiveService<TransactionModel>(box);
    return _hive.getData(_key) ?? TransactionModel(income: [], expense: []);
  }

  Future<void> addPayment(String paymentType, PaymentModel payment) async {
    log("paymentType: $paymentType ${payment.amount}");
    final transaction =
        state.value ?? TransactionModel(income: [], expense: []);
    final isIncome =
        paymentType.toLowerCase() == PaymentConstants.income.toLowerCase();
    final updatedTransaction =
        isIncome
            ? TransactionModel(
              income: [...transaction.income, payment],
              expense: transaction.expense,
            )
            : TransactionModel(
              income: transaction.income,
              expense: [...transaction.expense, payment],
            );

    state = AsyncData(updatedTransaction);

    try {
      await _hive.saveData(_key, updatedTransaction);
      log("List - ${updatedTransaction.expense.length}");
    } catch (e) {
      log("Error saving transaction: $e");
      state = AsyncData(transaction);
    }
  }
}

final transactionProvider =
    AsyncNotifierProvider<TransactionNotifier, TransactionModel>(
      () => TransactionNotifier(),
    );
