import 'package:finpal/app/app.dart';

class HomeConstants {
  static final List<NavModel> nav2 = [
    NavModel(
      icon: AppSvgs.bot,
      pathType: PathType.screenPath,
      screenPath: '/ai',
      defaultPath: const SizedBox.shrink(),
    ),
    NavModel(
      icon: AppSvgs.add1,
      pathType: PathType.screenPath,
      screenPath: '/add_amount',
      defaultPath: const SizedBox.shrink(),
    ),
    NavModel(
      icon: AppSvgs.add1,
      pathType: PathType.screenPath,
      screenPath: '/add_amount',
      defaultPath: const SizedBox.shrink(),
    ),
  ];

  static final List<NavModel> nav1 = [
    NavModel(icon: AppSvgs.home, defaultPath: ExpenseScreen()),
    NavModel(icon: AppSvgs.transaction, defaultPath: TransactionScreen()),
    NavModel(icon: AppSvgs.user, defaultPath: SettingsScreen()),
  ];
}
