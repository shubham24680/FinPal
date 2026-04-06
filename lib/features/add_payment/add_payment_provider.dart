import 'dart:developer';

import 'package:finpal/app/app.dart';

class PaymentState {
  final TextEditingController amountController;
  final TextEditingController notesController;
  final String date;
  final OptionModel? category;
  final OptionModel? paymentMethod;
  final bool isFilled;
  final bool isSaving;
  final bool isSaved;
  final String? overspent;

  PaymentState({
    required this.amountController,
    required this.notesController,
    required this.date,
    this.category,
    this.paymentMethod,
    required this.isFilled,
    required this.isSaving,
    required this.isSaved,
    this.overspent,
  });

  factory PaymentState.initial() => PaymentState(
    amountController: TextEditingController(),
    notesController: TextEditingController(),
    date: formatDate(DateTime.now()),
    isFilled: false,
    isSaving: false,
    isSaved: false,
  );

  PaymentState copyWith({
    String? date,
    OptionModel? category,
    OptionModel? paymentMethod,
    bool? isFilled,
    bool? isSaving,
    bool? isSaved,
    String? overspent,
  }) => PaymentState(
    amountController: amountController,
    notesController: notesController,
    date: date ?? this.date,
    category: category ?? this.category,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    isFilled: isFilled ?? this.isFilled,
    isSaving: isSaving ?? this.isSaving,
    isSaved: isSaved ?? this.isSaved,
    overspent: overspent,
  );
}

class PaymentProvider extends StateNotifier<PaymentState> {
  final Ref _ref;
  final String _type;

  PaymentProvider(this._ref, this._type) : super(PaymentState.initial());

  void setDate(String date) => state = state.copyWith(date: date);

  void setCategory(OptionModel category) =>
      state = state.copyWith(category: category);

  void setPaymentMethod(OptionModel paymentMethod) =>
      state = state.copyWith(paymentMethod: paymentMethod);

  void checkCondition(String? value) =>
      state = state.copyWith(isFilled: value?.isNotEmpty ?? false);

  void checkOverspent(String? value) {
    final totalIncome = _ref.read(transactionProvider).value?.totalIncome ?? 0;
    final totalExpense =
        _ref.read(transactionProvider).value?.totalExpense ?? 0;
    final amount = double.tryParse(value?.trim() ?? "") ?? 0;
    final totalAmount = (amount + totalExpense) - totalIncome;
    final isTrue = totalAmount > 0;
    state = state.copyWith(
      overspent: isTrue ? "Overspent by ${formatCurrency(totalAmount)} " : null,
    );
  }

  Future<void> addAmount() async {
    final rawAmount = state.amountController.text.trim();
    final amount = double.tryParse(rawAmount);
    if (amount == null || amount <= 0) return;

    state = state.copyWith(isSaving: true, isSaved: false);

    final notes = state.notesController.text.trim();
    final model = PaymentModel(
      paymentType: _type,
      amount: amount,
      date: state.date,
      category:
          state.category ?? const OptionModel(name: "Other", icon: AppSvgs.add),
      paymentMethod:
          state.paymentMethod ??
          const OptionModel(name: "Other", icon: AppSvgs.add),
      notes: notes.isEmpty ? null : notes,
    );

    await _ref.read(transactionProvider.notifier).addPayment(_type, model);
    log(
      'Saved $_type: ${model.amount} | ${model.category.name} | ${model.paymentMethod.name}',
      name: 'PaymentProvider',
    );

    state.amountController.clear();
    state.notesController.clear();
    if (!mounted) return;
    state = PaymentState.initial();
  }
}

final paymentProvider = StateNotifierProvider.family
    .autoDispose<PaymentProvider, PaymentState, String>(
      (ref, type) => PaymentProvider(ref, type),
    );
