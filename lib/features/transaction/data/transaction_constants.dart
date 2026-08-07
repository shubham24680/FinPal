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
