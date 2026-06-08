import 'package:finpal/app/app.dart';
import 'package:finpal/core/theme/app_theme.dart';

void main() async {
  final init = await AppInitializer.init();
  runApp(ProviderScope(overrides: init, child: const MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(AppRoutes.routesProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          title: 'FinPal',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system, // change to themeMode later
          routerConfig: routes,
        );
      },
    );
  }
}
