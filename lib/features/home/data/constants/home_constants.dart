import 'package:finpal/app/app.dart';

class HomeConstants {
  static final List<NavModel> navigationBar = [
    NavModel(
      id: 'home',
      page: AnalysisScreen(),
      selectedIcon: AppSvgs.home1,
      unselectedIcon: AppSvgs.home,
      title: 'Home',
    ),
    NavModel(
      id: 'transactions',
      page: TransactionScreen(),
      selectedIcon: AppSvgs.bills,
      unselectedIcon: AppSvgs.bills1,
      title: 'Transactions',
    ),
    NavModel(
      id: 'reports',
      page: AnalysisScreen(),
      selectedIcon: AppSvgs.report,
      unselectedIcon: AppSvgs.report1,
      title: 'Reports',
    ),
    NavModel(
      id: 'settings',
      page: SettingsScreen(),
      selectedIcon: AppSvgs.settings,
      unselectedIcon: AppSvgs.settings1,
      title: 'Settings',
    ),
  ];
}
