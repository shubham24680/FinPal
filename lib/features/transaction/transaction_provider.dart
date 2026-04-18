import 'package:finpal/app/app.dart';

final paymentBoxProvider = Provider<Box<PaymentModel>>(
  (ref) => throw UnimplementedError(),
);

class TransactionNotifier extends AsyncNotifier<TransactionService> {
  @override
  Future<TransactionService> build() async {
    final box = ref.watch(paymentBoxProvider);
    return TransactionService(box);
  }

  Future<void> save(PaymentModel payment) async {
    final updatedData = state.value;
    if (updatedData == null) return;
    await updatedData.save(payment);
    state = AsyncData(updatedData);
  }

  Future<void> saveAll(List<PaymentModel> payments) async {
    final updatedData = state.value;
    if (updatedData == null) return;
    await updatedData.saveAll(payments);
    state = AsyncData(updatedData);
  }
}

final transactionProvider =
    AsyncNotifierProvider<TransactionNotifier, TransactionService>(
      () => TransactionNotifier(),
    );
