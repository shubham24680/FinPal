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
  options(path: "/options", child: OptionsScreen()),
  ai(path: "/ai", child: AIScreen()),
  pinAuth(path: "/pin_auth", child: PinAuthScreen()),
  lockScreen(path: "/lock", child: LockScreen());

  const AppRoutesPath({required this.path, required this.child});
  final String path;
  final Widget child;
}

class AppRoutes {
  static bool isAppLocked = true;
  static final routesProvider = Provider<GoRouter>((ref) {
    final refresh = ValueNotifier<int>(0);
    ref.listen<AsyncValue<ProfileModel>>(profileNotifier, (_, __) {
      refresh.value++;
    });
    ref.onDispose(refresh.dispose);

    return GoRouter(
      refreshListenable: refresh,
      initialLocation: AppRoutesPath.home.path,
      redirect: (context, state) async {
        final profileAsync = ref.read(profileNotifier);
        if (!profileAsync.hasValue) {
          return null;
        }
        final profile = profileAsync.requireValue;
        final isFirstVisit = profile.isFirstTimeVisit;
        final isOnboarding =
            state.matchedLocation == AppRoutesPath.onboarding.path;
        if (isFirstVisit && !isOnboarding) {
          return AppRoutesPath.onboarding.path;
        }

        final isPasscodeEnabled = profile.isPasscodeEnabled;
        final isOnLockScreen =
            state.matchedLocation == AppRoutesPath.lockScreen.path;
        if (isPasscodeEnabled && isAppLocked && !isOnLockScreen) {
          return AppRoutesPath.lockScreen.path;
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
                AppRoutesPath.addAmount => AddAmountScreen(extra: extra),
                _ => AppRoutesPath.values[index].child,
              };

              return FadeTransitionPage(child: widget);
            },
          ),
        ),
      ],
    );
  });
}

class FadeTransitionPage<T> extends CustomTransitionPage<T> {
  FadeTransitionPage({required super.child})
    : super(
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
      );
}
