import 'package:finpal/app/app.dart';

class AppRoutes {
  static List<RouteModel> get paths => [
    RouteModel(path: "/onboarding", child: const OnboardingScreen()),
    RouteModel(path: "/", child: const HomeScreen()),
    RouteModel(path: "/add_amount", child: const AddAmountScreen()),
    RouteModel(path: "/edit_profile", child: const EditProfileScreen()),
    RouteModel(
      path: "/transaction_overview",
      child: const TransactionOverviewScreen(),
    ),
  ];

  static final routesProvider = Provider<GoRouter>((ref) {
    final profileAsync = ref.watch(profileNotifier);
    return GoRouter(
      initialLocation: "/",
      redirect: (context, state) {
        final profile = profileAsync.value;
        final isFirstVisit = profile?.isFistTimeVisit ?? true;
        final isOnboarding = state.matchedLocation == '/onboarding';
        if (isFirstVisit && !isOnboarding) {
          return '/onboarding';
        }

        return null;
      },
      routes: [
        ...List.generate(
          paths.length,
          (index) => GoRoute(
            path: paths[index].path,
            pageBuilder:
                (context, state) =>
                    FadeTransistionPage(child: paths[index].child),
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
