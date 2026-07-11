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
    date: DateTime.now().formatDate(),
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
  final String? _id;
  final Ref _ref;
  final String _type;

  PaymentProvider(this._ref, this._type, this._id)
    : super(PaymentState.initial()) {
    if (_id != null) {
      final payment = _ref.read(transactionProvider).value?.getPayment(_id);
      if (payment != null) {
        state.amountController.text =
            CurrencyFormatter.formatAmountForInput(payment.amount);
        state.notesController.text = payment.notes ?? "";
        state.copyWith(
          date: payment.date.formatDate(),
          category: _ref
              .read(optionNotifer)
              .value
              ?.findById(payment.categoryId),
          paymentMethod: _ref
              .read(optionNotifer)
              .value
              ?.findById(payment.paymentMethodId),
        );
      }
    }
  }

  void setDate(String date) => state = state.copyWith(date: date);

  void setCategory(OptionModel category) =>
      state = state.copyWith(category: category);

  void setPaymentMethod(OptionModel paymentMethod) =>
      state = state.copyWith(paymentMethod: paymentMethod);

  void checkCondition(String? value) =>
      state = state.copyWith(isFilled: value?.isNotEmpty ?? false);

  void checkOverspent(String? value) {
    final transactionProv = _ref.read(transactionProvider);
    final available = transactionProv.value?.available ?? 0;
    final amount = CurrencyFormatter.parse(value ?? '');
    final totalAmount = available - amount;
    final isOverspent = totalAmount < 0;
    state = state.copyWith(
      overspent:
          isOverspent
              ? "Overspent by ${CurrencyFormatter.format(totalAmount)} "
              : null,
    );
  }

  Future<void> addAmount() async {
    final amount = CurrencyFormatter.parse(state.amountController.text);
    if (amount <= 0) return;

    state = state.copyWith(isSaving: true, isSaved: false);

    final notes = state.notesController.text.trim();
    final payment = PaymentModel(
      id: _id,
      paymentType: _type,
      amount: amount,
      date: DateTime.parse(state.date),
      categoryId: state.category?.id,
      paymentMethodId: state.paymentMethod?.id,
      notes: notes,
    );

    await _ref.read(transactionProvider.notifier).save(payment);
    if (!mounted) return;
    state.amountController.clear();
    state.notesController.clear();
    state = PaymentState(
      amountController: state.amountController,
      notesController: state.notesController,
      date: DateTime.now().formatDate(),
      category: null,
      paymentMethod: null,
      isFilled: false,
      isSaving: false,
      isSaved: true,
      overspent: null,
    );
  }
}

final paymentProvider = StateNotifierProvider.family
    .autoDispose<PaymentProvider, PaymentState, (String, String?)>(
      (ref, args) => PaymentProvider(ref, args.$1, args.$2),
    );
