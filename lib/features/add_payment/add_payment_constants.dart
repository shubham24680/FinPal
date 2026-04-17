import 'package:finpal/app/app.dart';

class PaymentConstants {
  static const income = 'income';
  static const expense = 'expense';
  static const paymentMethod = 'payment_method';
  static const incomeCategory = 'income_category';
  static const expenseCategory = 'expense_category';

  static const otherPaymentMethodId = 'payment_method_other';
  static const otherIncomeCategoryId = 'income_category_other';
  static const otherExpenseCategoryId = 'expense_category_other';

  static final List<OptionModel> paymentMethods = [
    OptionModel(
      id: "payment_method_upi",
      type: paymentMethod,
      name: "UPI",
      icon: AppSvgs.upi,
    ),
    OptionModel(
      id: "payment_method_net_banking",
      type: paymentMethod,
      name: "Net Banking",
      icon: AppSvgs.netBanking,
    ),
    OptionModel(
      id: "payment_method_credit_card",
      type: paymentMethod,
      name: "Credit Card",
      icon: AppSvgs.card,
    ),
    OptionModel(
      id: "payment_method_debit_card",
      type: paymentMethod,
      name: "Debit Card",
      icon: AppSvgs.card,
    ),
    OptionModel(
      id: "payment_method_cash",
      type: paymentMethod,
      name: "Cash",
      icon: AppSvgs.cash,
    ),
    OptionModel(
      id: "payment_method_wallet",
      type: paymentMethod,
      name: "Wallet",
      icon: AppSvgs.wallet,
    ),
    OptionModel(
      id: otherPaymentMethodId,
      type: paymentMethod,
      name: "Other",
      icon: AppSvgs.add,
    ),
  ];

  static final List<OptionModel> incomeCategories = [
    OptionModel(
      id: "income_category_salary",
      type: incomeCategory,
      name: "Salary",
      icon: AppSvgs.salary,
    ),
    OptionModel(
      id: "income_category_freelance",
      type: incomeCategory,
      name: "Freelance",
      icon: AppSvgs.wadOfMoney,
    ),
    OptionModel(
      id: "income_category_investment",
      type: incomeCategory,
      name: "Investment",
      icon: AppSvgs.cash,
    ),
    OptionModel(
      id: "income_category_gift",
      type: incomeCategory,
      name: "Gift",
      icon: AppSvgs.gift,
    ),
    OptionModel(
      id: otherIncomeCategoryId,
      type: incomeCategory,
      name: "Other",
      icon: AppSvgs.add,
    ),
  ];

  static final List<OptionModel> expenseCategories = [
    OptionModel(
      id: "expense_category_food",
      type: expenseCategory,
      name: "Food",
      icon: AppSvgs.food,
    ),
    OptionModel(
      id: "expense_category_rent",
      type: expenseCategory,
      name: "Rent",
      icon: AppSvgs.rent,
    ),
    OptionModel(
      id: "expense_category_entertainment",
      type: expenseCategory,
      name: "Entertainment",
      icon: AppSvgs.entertainment,
    ),
    OptionModel(
      id: "expense_category_bills",
      type: expenseCategory,
      name: "Bills",
      icon: AppSvgs.bills,
    ),
    OptionModel(
      id: otherExpenseCategoryId,
      type: expenseCategory,
      name: "Other",
      icon: AppSvgs.add,
    ),
  ];

  static final List<OptionModel> allOptions = [
    ...paymentMethods,
    ...incomeCategories,
    ...expenseCategories,
  ];
}
