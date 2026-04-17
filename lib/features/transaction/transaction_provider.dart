import 'dart:developer';

import 'package:finpal/app/app.dart';

final paymentBoxProvider = Provider<Box<PaymentModel>>(
  (ref) => throw UnimplementedError(),
);

class TransactionNotifier extends AsyncNotifier<TransactionModel> {
  late HiveService<PaymentModel> _hiveService;
  late Box<PaymentModel> _box;

  @override
  Future<TransactionModel> build() async {
    _box = ref.watch(paymentBoxProvider);
    _hiveService = HiveService<PaymentModel>(_box);
    return TransactionModel(income: [], expense: []);
  }
}

final transactionProvider =
    AsyncNotifierProvider<TransactionNotifier, TransactionModel>(
      () => TransactionNotifier(),
    );
