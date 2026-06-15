import 'package:finpal/app/app.dart';

part 'payment_model.g.dart';

@HiveType(typeId: 1)
class PaymentModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String paymentType;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final String date;
  @HiveField(4)
  final String categoryId;
  @HiveField(5)
  final String paymentMethodId;
  @HiveField(6)
  final String? notes;

  PaymentModel({
    required this.paymentType,
    required this.amount,
    String? id,
    String? date,
    String? categoryId,
    String? paymentMethodId,
    this.notes,
  }) : id = id ?? Uuid().v7(),
       date = date ?? DateTime.now().formatDate(),
       categoryId = categoryId ?? _defaultCategoryId(paymentType),
       paymentMethodId = paymentMethodId ?? OnboardingConstants.paymentMethod;

  PaymentModel copyWith({
    String? id,
    String? paymentType,
    double? amount,
    String? date,
    String? categoryId,
    String? paymentMethodId,
    String? notes,
  }) => PaymentModel(
    id: id ?? this.id,
    paymentType: paymentType ?? this.paymentType,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    categoryId: categoryId ?? this.categoryId,
    paymentMethodId: paymentMethodId ?? this.paymentMethodId,
    notes: notes ?? this.notes,
  );
}

String _defaultCategoryId(String paymentType) {
  return (paymentType == OnboardingConstants.income)
      ? OnboardingConstants.incomeCategory
      : OnboardingConstants.expenseCategory;
}
