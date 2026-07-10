import 'package:finpal/app/app.dart';

class HomeConstants {
  static final List<NavModel> navigationBar = [
    NavModel(
      id: 'home',
      page: ExpenseScreen(),
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
      page: TransactionScreen(),
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
  // static final List<NavModel> nav2 = [
  //   NavModel(
  //     selectedIcon: AppSvgs.bot,
  //     pathType: PathType.screenPath,
  //     screenPath: '/ai',
  //     page: const SizedBox.shrink(),
  //   ),
  //   NavModel(
  //     selectedIcon: AppSvgs.add1,
  //     pathType: PathType.screenPath,
  //     screenPath: '/add_amount',
  //     page: const SizedBox.shrink(),
  //   ),
  //   NavModel(
  //     selectedIcon: AppSvgs.add1,
  //     pathType: PathType.screenPath,
  //     screenPath: '/add_amount',
  //     page: const SizedBox.shrink(),
  //   ),
  // ];

  // static final List<NavModel> nav1 = [
  //   NavModel(selectedIcon: AppSvgs.home, page: ExpenseScreen()),
  //   NavModel(selectedIcon: AppSvgs.bills1, page: TransactionScreen()),
  //   NavModel(selectedIcon: AppSvgs.user, page: SettingsScreen()),
  // ];
}
