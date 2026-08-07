import 'dart:math';

import 'package:finpal/app/app.dart';

enum OptionType {
  income("income_category", "Income Category", AppSvgs.income),
  expense("expense_category", "Expense Category", AppSvgs.expense),
  paymentMethod("payment_method", "Payment Method", AppSvgs.upi);

  const OptionType(this.id, this.name, this.icon);
  final String id, name, icon;
}

extension OptionTypeExtension on String {
  OptionType? get byId {
    final normalized = toLowerCase();
    return OptionType.values.firstWhere(
      (type) => type.id.toLowerCase() == normalized,
      orElse: () => OptionType.expense,
    );
  }
}

class OptionsConstant {
  static final OptionModel otherCategory = OptionModel(
    id: "other_category",
    type: "other_category",
    name: "Other",
    icon: AppSvgs.other,
  );

  static final List<OptionModel> paymentMethods = [
    OptionModel(
      type: OptionType.paymentMethod.id,
      name: "Cash",
      icon: AppSvgs.cash,
    ),
    OptionModel(
      type: OptionType.paymentMethod.id,
      name: "UPI",
      icon: AppSvgs.upi,
    ),
    OptionModel(
      type: OptionType.paymentMethod.id,
      name: "Credit Card",
      icon: AppSvgs.creditCard,
    ),
    OptionModel(
      type: OptionType.paymentMethod.id,
      name: "Debit Card",
      icon: AppSvgs.debitCard,
    ),
    OptionModel(
      type: OptionType.paymentMethod.id,
      name: "Net Banking",
      icon: AppSvgs.netBanking,
    ),
    OptionModel(
      type: OptionType.paymentMethod.id,
      name: "Wallet",
      icon: AppSvgs.wallet,
    ),
  ];

  static final List<OptionModel> incomeCategories = [
    OptionModel(
      type: OptionType.income.id,
      name: "Salary",
      icon: AppSvgs.salary,
    ),
    OptionModel(
      type: OptionType.income.id,
      name: "Freelance",
      icon: AppSvgs.freelance,
    ),
    OptionModel(
      type: OptionType.income.id,
      name: "Investment",
      icon: AppSvgs.investment,
    ),
    OptionModel(type: OptionType.income.id, name: "Gift", icon: AppSvgs.gift),
    OptionModel(
      type: OptionType.income.id,
      name: "Rental",
      icon: AppSvgs.rental,
    ),
  ];

  static final List<OptionModel> expenseCategories = [
    OptionModel(
      type: OptionType.expense.id,
      name: "Food & Dining",
      icon: AppSvgs.food,
    ),
    OptionModel(
      type: OptionType.expense.id,
      name: "Groceries",
      icon: AppSvgs.groceries,
    ),
    OptionModel(type: OptionType.expense.id, name: "Rent", icon: AppSvgs.rent),
    OptionModel(
      type: OptionType.expense.id,
      name: "Bills & Utilities",
      icon: AppSvgs.bills,
    ),
    OptionModel(
      type: OptionType.expense.id,
      name: "Recharge & Internet",
      icon: AppSvgs.recharge,
    ),
    OptionModel(
      type: OptionType.expense.id,
      name: "Transport & Fuel",
      icon: AppSvgs.transportation,
    ),
    OptionModel(
      type: OptionType.expense.id,
      name: "Shopping",
      icon: AppSvgs.shopping,
    ),
    OptionModel(
      type: OptionType.expense.id,
      name: "Entertainment",
      icon: AppSvgs.entertainment,
    ),
    OptionModel(
      type: OptionType.expense.id,
      name: "Health & Medical",
      icon: AppSvgs.health,
    ),
    OptionModel(
      type: OptionType.expense.id,
      name: "Party",
      icon: AppSvgs.party,
    ),
    OptionModel(
      type: OptionType.expense.id,
      name: "Education",
      icon: AppSvgs.education,
    ),
  ];

  static final List<OptionModel> allOptions = [
    ...paymentMethods,
    ...incomeCategories,
    ...expenseCategories,
  ].map((e) => e.copyWith(color: randomColorSet.name)).toList(growable: false);
}

ColorSet get randomColorSet =>
    ColorSet.values.elementAt(Random().nextInt(ColorSet.values.length));
