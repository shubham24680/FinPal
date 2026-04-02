import 'package:finpal/app/app.dart';

class HomeConstants {
  static final NavModel addAmount = NavModel(
    icon: AppSvgs.add,
    screenPath: const SizedBox.shrink(),
  );
  static final List<NavModel> navs = [
    NavModel(icon: AppSvgs.home, screenPath: ExpenseScreen()),
    NavModel(icon: AppSvgs.transaction, screenPath: TransactionScreen()),
    NavModel(icon: AppSvgs.profile, screenPath: ProfileScreen()),
  ];
}
