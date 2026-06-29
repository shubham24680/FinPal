import 'package:finpal/app/app.dart';

class OptionsConstant {
  static const income = 'income';
  static const expense = 'expense';
  static const paymentMethod = 'payment_method';
  static const incomeCategory = 'income_category';
  static const expenseCategory = 'expense_category';

  static final List<OptionModel> paymentMethods = [
    OptionModel(
      id: paymentMethod,
      type: paymentMethod,
      name: "Other",
      icon: AppSvgs.other,
    ), 
    OptionModel(type: paymentMethod, name: "Cash", icon: AppSvgs.cash),
    OptionModel(type: paymentMethod, name: "UPI", icon: AppSvgs.upi),
    OptionModel(
      type: paymentMethod,
      name: "Credit Card",
      icon: AppSvgs.creditCard,
    ),
    OptionModel(
      type: paymentMethod,
      name: "Debit Card",
      icon: AppSvgs.debitCard,
    ),
    OptionModel(
      type: paymentMethod,
      name: "Net Banking",
      icon: AppSvgs.netBanking,
    ),
    OptionModel(type: paymentMethod, name: "Wallet", icon: AppSvgs.wallet),
  ];

  static final List<OptionModel> incomeCategories = [
    OptionModel(
      id: incomeCategory,
      type: incomeCategory,
      name: "Other",
      icon: AppSvgs.add,
    ),
    OptionModel(type: incomeCategory, name: "Salary", icon: AppSvgs.salary),
    OptionModel(
      type: incomeCategory,
      name: "Freelance",
      icon: AppSvgs.freelance,
    ),
    OptionModel(
      type: incomeCategory,
      name: "Investment",
      icon: AppSvgs.investment,
    ),
    OptionModel(type: incomeCategory, name: "Gift", icon: AppSvgs.gift),
    OptionModel(type: incomeCategory, name: "Rental", icon: AppSvgs.rental),
  ];

  static final List<OptionModel> expenseCategories = [
    OptionModel(
      id: expenseCategory,
      type: expenseCategory,
      name: "Other",
      icon: AppSvgs.other,
    ),
    OptionModel(
      type: expenseCategory,
      name: "Food & Dining",
      icon: AppSvgs.food,
    ),
    OptionModel(
      type: expenseCategory,
      name: "Groceries",
      icon: AppSvgs.groceries,
    ),
    OptionModel(type: expenseCategory, name: "Rent", icon: AppSvgs.rent),
    OptionModel(
      type: expenseCategory,
      name: "Bills & Utilities",
      icon: AppSvgs.bills,
    ),
    OptionModel(
      type: expenseCategory,
      name: "Recharge & Internet",
      icon: AppSvgs.recharge,
    ),
    OptionModel(
      type: expenseCategory,
      name: "Transport & Fuel",
      icon: AppSvgs.transportation,
    ),
    OptionModel(
      type: expenseCategory,
      name: "Shopping",
      icon: AppSvgs.shopping,
    ),
    OptionModel(
      type: expenseCategory,
      name: "Entertainment",
      icon: AppSvgs.entertainment,
    ),
    OptionModel(
      type: expenseCategory,
      name: "Health & Medical",
      icon: AppSvgs.health,
    ),
    OptionModel(type: expenseCategory, name: "Party", icon: AppSvgs.party),
    OptionModel(
      type: expenseCategory,
      name: "Education",
      icon: AppSvgs.education,
    ),
  ];

  static final List<OptionModel> allOptions = [
    ...paymentMethods,
    ...incomeCategories,
    ...expenseCategories,
  ];
}