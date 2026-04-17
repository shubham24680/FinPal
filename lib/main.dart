import 'package:finpal/app/app.dart';
import 'package:flutter/services.dart';

void main() async {
  final init = await AppInitializer.init();
  runApp(ProviderScope(overrides: init, child: const MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(AppRoutes.routesProvider);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: BGColors.shade50,
      ),
    );

    return ScreenUtilInit(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: routes,
      ),
    );
  }
}
