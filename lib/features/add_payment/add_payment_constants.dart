import 'package:finpal/app/app.dart';

class PaymentConstants {
  static const income = 'income';
  static const expense = 'expense';

  static const List<OptionModel> paymentMethods = [
    OptionModel(name: "UPI", icon: AppSvgs.upi),
    OptionModel(name: "Net Banking", icon: AppSvgs.netBanking),
    OptionModel(name: "Credit Card", icon: AppSvgs.card),
    OptionModel(name: "Debit Card", icon: AppSvgs.card),
    OptionModel(name: "Cash", icon: AppSvgs.cash),
    OptionModel(name: "Wallet", icon: AppSvgs.wallet),
    OptionModel(name: "Other", icon: AppSvgs.add),
  ];

  static const List<OptionModel> incomeCategories = [
    OptionModel(name: "Salary", icon: AppSvgs.salary),
    OptionModel(name: "Freelance", icon: AppSvgs.wadOfMoney),
    OptionModel(name: "Investment", icon: AppSvgs.cash),
    OptionModel(name: "Gift", icon: AppSvgs.gift),
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
