import 'package:finpal/app/app.dart';

enum TransactionType {
  income("income", "Income", AppSvgs.arrowDown, ColorSet.primary, OptionType.income),
  expense("expense", "Expense", AppSvgs.arrowUp, ColorSet.error, OptionType.expense);

  const TransactionType(this.id, this.name, this.icon, this.color, this.optionType);
  final String id, name, icon;
  final ColorSet color;
  final OptionType optionType;
}

extension TransactionTypeX on String {
  TransactionType get type => TransactionType.values.firstWhere(
    (value) => value.id == toLowerCase(),
    orElse: () => TransactionType.expense,
  );
}

class TransactionConstants {
  static const String emptyHelperText = "Enter an amount to see what's left.";
  static const String savingHelperText = "You'll still have ";
  static const String overspentHelperText = "You'd be short by ";
  static const String neutralHelperText = "This uses up your remaining balance.";

  static const int maxReceiptSizeBytes = 5 * 1024 * 1024;
  static const List<String> allowedReceiptExtensions = [
    'jpg',
    'jpeg',
    'png',
  ];

  static const String amountInvalidMessage = "Enter a valid amount";
  static const String receiptNotFoundMessage = "Receipt file not found";
  static const String receiptTypeMessage =
      "Only JPG, PNG or JPEG receipts are allowed";
  static const String receiptSizeMessage = "Receipt must be 5MB or smaller";
  static const String saveSuccessMessage = "Transaction saved successfully";
  static const String saveFailureMessage = "Failed to save transaction";
}