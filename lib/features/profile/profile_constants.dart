import 'package:finpal/app/app.dart';

class ProfileConstants {
  static const List<OptionModel> gender = [
    OptionModel(icon: AppSvgs.male, name: "Male"),
    OptionModel(icon: AppSvgs.female, name: "Female"),
    OptionModel(icon: AppSvgs.add, name: "Other"),
  ];

  static List<OptionModel> contentList = [
    OptionModel(
      icon: AppSvgs.addPayment,
      name: "Add Income/Expense",
      screenPath: "/add_amount",
    ),
  ];
}
