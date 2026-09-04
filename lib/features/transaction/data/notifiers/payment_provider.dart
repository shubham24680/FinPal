import 'dart:developer';
import 'package:finpal/app/app.dart';

final selectedTransactionProvider = StateProvider<PaymentModel?>((ref) => null);

class PaymentState {
  final String? id;
  final TransactionType type;
  final double initialAmount;
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
  final String helperText;
  final ColorSet helperTextColor;

  PaymentState({
    this.id,
    required this.type,
    required this.initialAmount,
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
    required this.helperText,
    required this.helperTextColor,
  });

  factory PaymentState.initial() => PaymentState(
    type: TransactionType.expense,
    initialAmount: 0,
    amount: '',
    date: DateTime.now().formatDate(type: DateFormatType.dateTime),
    buttonState: ButtonState.disabled,
    overspent: '',
    notes: '',
    receiptPath: '',
    toastType: ToastType.normal,
    toastMessage: '',
    helperText: TransactionConstants.emptyHelperText,
    helperTextColor: ColorSet.neutral,
  );

  PaymentState copyWith({
    String? id,
    TransactionType? type,
    double? initialAmount,
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
    String? helperText,
    ColorSet? helperTextColor,
  }) => PaymentState(
    id: id ?? this.id,
    type: type ?? this.type,
    initialAmount: initialAmount ?? this.initialAmount,
    amount: amount ?? this.amount,
    date: date?.formatDate(type: DateFormatType.dateTime) ?? this.date,
    category:
        (type == null || type == this.type)
            ? category ?? this.category
            : category,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    buttonState: buttonState ?? this.buttonState,
    overspent: overspent ?? this.overspent,
    notes: notes?.trim() ?? this.notes,
    receiptPath: receiptPath?.trim() ?? this.receiptPath,
    createdAt: createdAt ?? this.createdAt,
    toastType: toastType ?? this.toastType,
    toastMessage: toastMessage ?? this.toastMessage,
    helperText: helperText ?? this.helperText,
    helperTextColor: helperTextColor ?? this.helperTextColor,
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

    final type = selectedTransaction.paymentType.type;
    final amount = _ref.formatAmountForInput(
      selectedTransaction.amount,
    );
    final options = _ref.read(optionNotifer).value;
    final category = options?.findById(selectedTransaction.categoryId);
    final paymentMethod = options?.findById(
      selectedTransaction.paymentMethodId,
    );

    state = state.copyWith(
      id: selectedTransaction.id,
      type: type,
      initialAmount:
          type == TransactionType.expense
              ? -selectedTransaction.amount
              : selectedTransaction.amount,
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
    if (receiptPath != null && receiptPath.isNotEmpty) {
      final receiptError = ReceiptUtils.validateReceipt(receiptPath);
      if (receiptError != null) {
        _showError(receiptError);
        return;
      }
    }

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
    if (amount != null || type != null) {
      checkSpent();
    }
  }

  void onChange() {
    final isValid = state.amount.isNotEmpty && state.date.isNotEmpty;
    state = state.copyWith(
      buttonState: isValid ? ButtonState.enabled : ButtonState.disabled,
    );
  }

  void checkSpent() {
    if (state.amount.isEmpty) {
      state = state.copyWith(
        helperText: TransactionConstants.emptyHelperText,
        helperTextColor: ColorSet.neutral,
      );
      return;
    }

    final transactionProv = _ref.read(transactionProvider);
    final available =
        (transactionProv.value?.availableBalance ?? 0) - state.initialAmount;
    final amount = _ref.parseCurrency(state.amount);
    final totalAmount =
        state.type == TransactionType.expense
            ? available - amount
            : available + amount;
    final amountInText = _ref.formatCurrency(totalAmount.abs());
    final helperText =
        totalAmount < 0
            ? "${TransactionConstants.overspentHelperText}$amountInText"
            : totalAmount > 0
            ? "${TransactionConstants.savingHelperText}$amountInText"
            : TransactionConstants.neutralHelperText;
    final helperTextColor =
        totalAmount < 0
            ? ColorSet.error
            : totalAmount > 0
            ? ColorSet.primary
            : ColorSet.neutral;
    state = state.copyWith(
      helperText: helperText,
      helperTextColor: helperTextColor,
    );
  }

  void clearToast() {
    if (state.toastMessage.isEmpty && state.toastType == ToastType.normal) {
      return;
    }
    state = state.copyWith(toastType: ToastType.normal, toastMessage: '');
  }

  void _showError(String message) {
    state = state.copyWith(toastType: ToastType.error, toastMessage: message);
  }

  Future<void> save() async {
    final category = state.category;
    final paymentMethod = state.paymentMethod;

    try {
      final amount = _ref.parseCurrency(state.amount);
      final date = state.date.parseDate(type: DateFormatType.dateTime);
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
      state = state.copyWith(
        toastType: ToastType.success,
        toastMessage: TransactionConstants.saveSuccessMessage,
      );
    } on FormatException catch (e, stackTrace) {
      log(e.toString(), name: "PaymentProvider", stackTrace: stackTrace);
      _showError(TransactionConstants.amountInvalidMessage);
    } catch (e, stackTrace) {
      log(e.toString(), name: "PaymentProvider", stackTrace: stackTrace);
      _showError(TransactionConstants.saveFailureMessage);
    }
  }
}

final paymentProvider =
    StateNotifierProvider.autoDispose<PaymentProvider, PaymentState>(
      (ref) => PaymentProvider(ref),
    );
