import 'package:finpal/app/app.dart';

part 'payment_model.g.dart';

@HiveType(typeId: 5)
class PaymentModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String paymentType;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String categoryId;
  @HiveField(5)
  final String paymentMethodId;
  @HiveField(6)
  final String? notes;
  @HiveField(7)
  final DateTime createdAt;
  @HiveField(8)
  final DateTime updatedAt;
  @HiveField(9)
  final String? receiptPath;

  PaymentModel({
    required this.paymentType,
    required this.amount,
    String? id,
    DateTime? date,
    String? categoryId,
    String? paymentMethodId,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.receiptPath,
  }) : id = id ?? Uuid().v7(),
       categoryId = categoryId ?? _defaultCategoryId(paymentType),
       paymentMethodId = paymentMethodId ?? OptionType.paymentMethod.id,
       date = date ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  PaymentModel copyWith({
    String? id,
    String? paymentType,
    double? amount,
    DateTime? date,
    String? categoryId,
    String? paymentMethodId,
    String? notes,
    DateTime? updatedAt,
    String? receiptPath,
  }) => PaymentModel(
    id: id ?? this.id,
    paymentType: paymentType ?? this.paymentType,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    categoryId: categoryId ?? this.categoryId,
    paymentMethodId: paymentMethodId ?? this.paymentMethodId,
    notes: notes ?? this.notes,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt,
    receiptPath: receiptPath ?? this.receiptPath,
  );
}

String _defaultCategoryId(String paymentType) {
  return (paymentType == OptionsConstant.income)
      ? OptionType.income.id
      : OptionType.expense.id;
}
