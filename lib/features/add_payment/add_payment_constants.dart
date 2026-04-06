import 'package:finpal/app/app.dart';

class PaymentConstants {
  static const income = 'income';
  static const expense = 'expense';

  static const List<OptionModel> paymentMethods = [
    OptionModel(name: "UPI", icon: AppSvgs.money),
    OptionModel(name: "Net Banking", icon: AppSvgs.money),
    OptionModel(name: "Credit Card", icon: AppSvgs.money),
    OptionModel(name: "Debit Card", icon: AppSvgs.money),
    OptionModel(name: "Cash", icon: AppSvgs.money),
    OptionModel(name: "Wallet", icon: AppSvgs.money),
    OptionModel(name: "Other", icon: AppSvgs.add),
  ];

  static const List<OptionModel> incomeCategories = [
    OptionModel(name: "Salary", icon: AppSvgs.money),
    OptionModel(name: "Freelance", icon: AppSvgs.money),
    OptionModel(name: "Investment", icon: AppSvgs.money),
    OptionModel(name: "Gift", icon: AppSvgs.money),
    OptionModel(name: "Other", icon: AppSvgs.add),
  ];

  static const List<OptionModel> expenseCategories = [
    OptionModel(name: "Food", icon: AppSvgs.food),
    OptionModel(name: "Rent", icon: AppSvgs.rent),
    OptionModel(name: "Entertainment", icon: AppSvgs.entertainment),
    OptionModel(name: "Bills", icon: AppSvgs.bills),
    OptionModel(name: "Other", icon: AppSvgs.add),
  ];
}
