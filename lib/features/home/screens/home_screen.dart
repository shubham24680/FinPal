import 'package:finpal/app/app.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navIndex = ref.watch(navProvider);

    return Scaffold(
      body: IndexedStack(
        index: navIndex,
        children: HomeConstants.nav1.map((e) => e.defaultPath).toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BottomNavBar(),
    );
  }
}
