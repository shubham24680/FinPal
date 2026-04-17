import 'package:finpal/app/app.dart';

enum AppRoutesPath {
  onboarding(path: "/onboarding", child: OnboardingScreen()),
  home(path: "/", child: HomeScreen()),
  addAmount(path: "/add_amount", child: AddAmountScreen()),
  editProfile(path: "/edit_profile", child: EditProfileScreen()),
  transactionOverview(
    path: "/transaction_overview",
    child: TransactionOverviewScreen(),
  ),
  options(path: "/options", child: OptionsScreen());

  const AppRoutesPath({required this.path, required this.child});
  final String path;
  final Widget child;
}

class AppRoutes {
  static final routesProvider = Provider<GoRouter>((ref) {
    final profileAsync = ref.watch(profileNotifier);
    return GoRouter(
      initialLocation: AppRoutesPath.home.path,
      redirect: (context, state) {
        final profile = profileAsync.value;
        final isFirstVisit = profile?.isFistTimeVisit ?? true;
        final isOnboarding =
            state.matchedLocation == AppRoutesPath.onboarding.path;
        if (isFirstVisit && !isOnboarding) {
          return AppRoutesPath.onboarding.path;
        }

        return null;
      },
      routes: [
        ...List.generate(
          AppRoutesPath.values.length,
          (index) => GoRoute(
            path: AppRoutesPath.values[index].path,
            pageBuilder: (context, state) {
              final extra = state.extra as ExtraModel?;
              final widget = switch (AppRoutesPath.values[index]) {
                AppRoutesPath.options => OptionsScreen(extra: extra),
                _ => AppRoutesPath.values[index].child,
              };

              return FadeTransistionPage(child: widget);
            },
          ),
        ),
      ],
    );
  });
}

class FadeTransistionPage<T> extends CustomTransitionPage<T> {
  FadeTransistionPage({required super.child})
    : super(
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
      );
}
