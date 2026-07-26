import 'package:finpal/app/app.dart';
import 'package:flutter/services.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navIndex = ref.watch(navProvider);
    final isDark = context.isDarkMode;

    return AnnotatedRegion(
      value: (isDark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light)
          .copyWith(
            statusBarColor: context.colors.surface,
            statusBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          ),
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: navIndex,
          children: HomeConstants.navigationBar.map((e) => e.page).toList(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: const AnimatedFab(),
        bottomNavigationBar: _bottomNavigationBar(context, ref, navIndex),
      ),
    );
  }

  Widget _bottomNavigationBar(
    BuildContext context,
    WidgetRef ref,
    int navIndex,
  ) {
    final length = HomeConstants.navigationBar.length;
    final firstHalfItems = HomeConstants.navigationBar.sublist(0, length ~/ 2);
    final secondHalfItems = HomeConstants.navigationBar.sublist(length ~/ 2);

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomAppBar(
        color: context.colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.spMin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...List.generate(
              firstHalfItems.length,
              (index) => _buildBNBItems(
                context,
                ref,
                firstHalfItems[index],
                index,
                navIndex,
              ),
            ),
            SizedBox(width: 40.spMin),
            ...List.generate(
              secondHalfItems.length,
              (index) => _buildBNBItems(
                context,
                ref,
                secondHalfItems[index],
                index + length ~/ 2,
                navIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBNBItems(
    BuildContext context,
    WidgetRef ref,
    NavModel item,
    int index,
    int navIndex,
  ) {
    final isSelected = index == navIndex;
    final selected = item.selectedIcon ?? item.unselectedIcon;
    final unselected = item.unselectedIcon ?? item.selectedIcon;

    final child = Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 4.spMin,
      children: [
        CustomImage(
          imageUrl: isSelected ? selected : unselected,
          color:
              isSelected
                  ? context.colors.inverseSurface
                  : context.colors.onSurface,
          imageType: ImageType.svgLocal,
        ),
        CustomTypography(
          text: item.title,
          fontType: FontType.label1Medium,
          color:
              isSelected
                  ? context.colors.inverseSurface
                  : context.colors.onSurface,
        ),
      ],
    );

    return AnimatedTap(
      onTap: () => ref.read(navProvider.notifier).state = index,
      child: child,
    );
  }
}
