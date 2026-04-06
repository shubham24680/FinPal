import 'package:finpal/app/app.dart';

part 'add_payment_model.g.dart';

@HiveType(typeId: 3)
class PaymentModel {
  @HiveField(0)
  final String paymentType;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final String date;
  @HiveField(3)
  final OptionModel category;
  @HiveField(4)
  final OptionModel paymentMethod;
  @HiveField(5)
  final String? notes;

  PaymentModel({
    required this.paymentType,
    required this.amount,
    required this.date,
    required this.category,
    required this.paymentMethod,
    this.notes,
  });
}
