import 'package:finpal/app/app.dart';

class AppRoutes {
  static List<RouteModel> get paths => [
    RouteModel(path: "/onboarding", child: const OnboardingScreen()),
    RouteModel(path: "/", child: const HomeScreen()),
    RouteModel(path: "/add_amount", child: const AddAmountScreen()),
  ];

  static final GoRouter routes = GoRouter(
    initialLocation: "/onboarding",
    // redirect: (context, state) async {
    //   // final prefs = await SPD.getInstance();
    //   // final isFirstTimeVisit = prefs.get<bool>(StorageKey.FIRST_VISIT) ?? true;
    //   final isFirstTimeVisit = true;

    //   if (isFirstTimeVisit) return "/onboarding";
    //   // return null;
    // },
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
}

class FadeTransistionPage<T> extends CustomTransitionPage<T> {
  FadeTransistionPage({required super.child})
    : super(
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
      );
}
