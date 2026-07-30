import 'package:finpal/app/app.dart';

enum AppRoutesPath {
  splash(path: "/", child: SplashScreen()),
  onboarding(path: "/onboarding", child: OnboardingScreen()),
  lockScreen(path: "/lock", child: LockScreen()),
  home(path: "/home", child: ScreensWithNavbar()),
  profile(path: "/profile", child: ProfileScreen()),
  editProfile(path: "/edit_profile", child: EditProfileScreen()),
  options(path: "/options", child: OptionsScreen()),
  editOption(path: "/edit_option", child: EditOptionScreen()),
  theme(path: "/theme", child: ThemeScreen()),
  currency(path: "/currency", child: CurrencyScreen()),
  editTransaction(path: "/edit_transaction", child: EditTransactionScreen()),
  ai(path: "/ai", child: AIScreen()),
  pinAuth(path: "/pin_auth", child: PinAuthScreen());

  const AppRoutesPath({required this.path, required this.child});
  final String path;
  final Widget child;
}

class AppRoutes {
  static bool isAppLocked = true;
  static final routesProvider = Provider<GoRouter>((ref) {
    final refresh = ValueNotifier<int>(0);
    ref.listen<AsyncValue<SettingsModel>>(settingsNotifier, (_, __) {
      refresh.value++;
    });
    ref.onDispose(refresh.dispose);

    return GoRouter(
      refreshListenable: refresh,
      initialLocation: AppRoutesPath.home.path,
      redirect: (context, state) {
        final settingsAsync = ref.read(settingsNotifier);
        final location = state.matchedLocation;
        final isOnSplash = location == AppRoutesPath.splash.path;

        //Splash Screen
        if (settingsAsync.isLoading && !isOnSplash) {
          return AppRoutesPath.splash.path;
        }
        if (!settingsAsync.hasValue) {
          return null;
        }

        //Onboaring
        final settings = settingsAsync.requireValue;
        final isFirstVisit = settings.isFirstVisit;
        if (isFirstVisit) {
          return AppRoutesPath.onboarding.path;
        }

        // final isPasscodeEnabled = settings.isPasscodeEnabled;
        // final isOnLockScreen =
        //     state.matchedLocation == AppRoutesPath.lockScreen.path;
        // if (isPasscodeEnabled && isAppLocked && !isOnLockScreen) {
        //   return AppRoutesPath.lockScreen.path;
        // }

        isAppLocked = false;
        final isOnboarding = location == AppRoutesPath.onboarding.path;
        if (isOnboarding || isOnSplash) {
          return AppRoutesPath.home.path;
        }

        return null;
      },
      routes: [
        ...List.generate(
          AppRoutesPath.values.length,
          (index) => GoRoute(
            path: AppRoutesPath.values[index].path,
            pageBuilder: (context, state) => FadeTransitionPage(
              child: AppRoutesPath.values[index].child,
            ),
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
