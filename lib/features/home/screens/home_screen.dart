import 'package:finpal/app/app.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navIndex = ref.watch(navProvider);

    return Scaffold(
      body: IndexedStack(
        index: navIndex,
        children: HomeConstants.navs.map((e) => e.screenPath).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BottomNavBar(),
    );
  }
}
