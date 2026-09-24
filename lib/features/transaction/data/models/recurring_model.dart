import 'package:finpal/app/app.dart';
part 'recurring_model.g.dart';

@HiveType(typeId: 6)
class RecurringModel {
  @HiveField(0)
  final String id;
  @HiveField(1, defaultValue: 0)
  final int frequency;
  @HiveField(2, defaultValue: false)
  final bool isActive;
  @HiveField(3)
  final DateTime date;
  @HiveField(4, defaultValue: "daily")
  final String interval;
  @HiveField(5, defaultValue: "never")
  final String endType;
  @HiveField(6)
  final DateTime? endDate;
  @HiveField(7)
  final DateTime lastPaymentDate;
  @HiveField(8)
  final DateTime nextPaymentDate;
  @HiveField(9)
  final DateTime createdAt;
  @HiveField(10)
  final DateTime updatedAt;
  @HiveField(11)
  final String paymentType;
  @HiveField(12)
  final double amount;
  @HiveField(13)
  final String categoryId;
  @HiveField(14)
  final String paymentMethodId;
  @HiveField(15)
  final String notes;
  @HiveField(16)
  final String receiptPath;

  RecurringModel({
    String? id,
    this.frequency = 0,
    this.isActive = false,
    DateTime? date,
    String? interval,
    String? endType,
    this.endDate,
    DateTime? lastPaymentDate,
    DateTime? nextPaymentDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.paymentType,
    required this.amount,
    String? categoryId,
    String? paymentMethodId,
    this.notes = "",
    this.receiptPath = "",
  }) : id = (id == null || id.isEmpty) ? const Uuid().v4() : id,
       interval = interval ?? RecurringInterval.daily.name,
       endType = endType ?? RecurringEndType.never.name,
       categoryId = categoryId ?? OptionsConstant.otherCategory.id,
       paymentMethodId = paymentMethodId ?? OptionsConstant.otherCategory.id,
       date = date ?? DateTime.now(),
       lastPaymentDate = lastPaymentDate ?? DateTime.now(),
       nextPaymentDate = nextPaymentDate ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  RecurringModel copyWith({
    String? id,
    int? frequency,
    bool? isActive,
    DateTime? date,
    String? interval,
    String? endType,
    DateTime? endDate,
    DateTime? lastPaymentDate,
    DateTime? nextPaymentDate,
    DateTime? updatedAt,
    String? paymentType,
    double? amount,
    String? categoryId,
    String? paymentMethodId,
    String? notes,
    String? receiptPath,
  }) => RecurringModel(
    id: id ?? this.id,
    frequency: frequency ?? this.frequency,
    isActive: isActive ?? this.isActive,
    date: date ?? this.date,
    interval: interval ?? this.interval,
    endType: endType ?? this.endType,
    endDate: endDate ?? this.endDate,
    lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
    nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    paymentType: paymentType ?? this.paymentType,
    amount: amount ?? this.amount,
    categoryId: categoryId ?? this.categoryId,
    paymentMethodId: paymentMethodId ?? this.paymentMethodId,
    notes: notes ?? this.notes,
    receiptPath: receiptPath ?? this.receiptPath,
  );
}
