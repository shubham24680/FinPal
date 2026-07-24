import 'dart:developer';
import 'package:finpal/app/app.dart';

final selectedTransactionProvider = StateProvider.autoDispose<PaymentModel?>(
  (ref) => null,
);

class PaymentState {
  final String id;
  final TransactionType type;
  final String amount;
  final String date;
  final OptionModel? category;
  final OptionModel? paymentMethod;
  final ButtonState buttonState;
  final String overspent;
  final String notes;
  final String receiptPath;
  final DateTime? createdAt;
  final ToastType toastType;
  final String toastMessage;

  PaymentState({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.category,
    this.paymentMethod,
    required this.buttonState,
    required this.overspent,
    required this.notes,
    required this.receiptPath,
    this.createdAt,
    required this.toastType,
    required this.toastMessage,
  });

  factory PaymentState.initial() => PaymentState(
    id: '',
    type: TransactionType.expense,
    amount: '',
    date: DateTime.now().formatDate(),
    buttonState: ButtonState.disabled,
    overspent: '',
    notes: '',
    receiptPath: '',
    toastType: ToastType.normal,
    toastMessage: '',
  );

  PaymentState copyWith({
    String? id,
    TransactionType? type,
    String? amount,
    DateTime? date,
    OptionModel? category,
    OptionModel? paymentMethod,
    ButtonState? buttonState,
    String? overspent,
    String? notes,
    String? receiptPath,
    DateTime? createdAt,
    ToastType? toastType,
    String? toastMessage,
  }) => PaymentState(
    id: id ?? this.id,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    date: date?.formatDate() ?? this.date,
    category:
        (type == null || type == this.type) ? category ?? this.category : null,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    buttonState: buttonState ?? this.buttonState,
    overspent: overspent ?? this.overspent,
    notes: notes ?? this.notes,
    receiptPath: receiptPath ?? this.receiptPath,
    createdAt: createdAt ?? this.createdAt,
    toastType: toastType ?? this.toastType,
    toastMessage: toastMessage ?? this.toastMessage,
  );
}

class PaymentProvider extends StateNotifier<PaymentState> {
  final Ref _ref;

  PaymentProvider(this._ref) : super(PaymentState.initial()) {
    _loadData();
  }

  void _loadData() {
    final selectedTransaction = _ref.read(selectedTransactionProvider);
    if (selectedTransaction == null) return;

    final amount = CurrencyFormatter.formatAmountForInput(
      selectedTransaction.amount,
    );
    final options = _ref.read(optionNotifer).value;
    final category = options?.findById(selectedTransaction.categoryId);
    final paymentMethod = options?.findById(
      selectedTransaction.paymentMethodId,
    );

    state = state.copyWith(
      id: selectedTransaction.id,
      type: selectedTransaction.paymentType.type,
      amount: amount,
      date: selectedTransaction.date,
      category: category,
      paymentMethod: paymentMethod,
      notes: selectedTransaction.notes,
      receiptPath: selectedTransaction.receiptPath,
      createdAt: selectedTransaction.createdAt,
    );
  }

  void set({
    TransactionType? type,
    String? amount,
    DateTime? date,
    OptionModel? category,
    OptionModel? paymentMethod,
    String? notes,
    String? receiptPath,
  }) {
    state = state.copyWith(
      type: type,
      amount: amount,
      date: date,
      category: category,
      paymentMethod: paymentMethod,
      notes: notes,
      receiptPath: receiptPath,
    );
    onChange();
  }

  void onChange() {
    final isValid = state.amount.isNotEmpty && state.date.isNotEmpty;
    state = state.copyWith(
      buttonState: isValid ? ButtonState.enabled : ButtonState.disabled,
    );
  }

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

  Future<void> save() async {
    final optionProv = _ref.read(optionNotifer).value;
    final category =
        state.category ??
        optionProv?.findByName('Other', state.type.optionType.id);
    final paymentMethod =
        state.paymentMethod ??
        optionProv?.findByName('Other', OptionType.paymentMethod.id);
    log(
      "type: ${state.type}, amount: ${state.amount}, date: ${state.date}, category: ${category?.name}, paymentMethod: ${paymentMethod?.name}, notes: ${state.notes}, receiptPath: ${state.receiptPath}",
      name: "PaymentProvider",
    );

    try {
      final amount = CurrencyFormatter.parse(state.amount);
      final date = state.date.parseDate();
      final transaction = PaymentModel(
        id: state.id,
        paymentType: state.type.id,
        amount: amount,
        date: date,
        categoryId: category?.id,
        paymentMethodId: paymentMethod?.id,
        notes: state.notes,
        receiptPath: state.receiptPath,
        createdAt: state.createdAt,
      );

      await _ref.read(transactionProvider.notifier).save(transaction);
      state = state.copyWith(toastMessage: "Transaction saved successfully");
    } catch (e) {
      log(e.toString(), name: "PaymentProvider");
      state = state.copyWith(
        toastType: ToastType.error,
        toastMessage: "Failed to save transaction",
      );
    }
    finally {
      state = state.copyWith(toastType: ToastType.normal, toastMessage: '');
    }
  }
}

final paymentProvider =
    StateNotifierProvider.autoDispose<PaymentProvider, PaymentState>(
      (ref) => PaymentProvider(ref),
    );
