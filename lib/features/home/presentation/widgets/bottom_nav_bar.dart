import 'package:finpal/app/app.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navIndex = ref.watch(navProvider);
    final navNotifier = ref.read(navProvider.notifier);
    final shadow = [
      BoxShadow(
        color: Colors.black.withAlpha(50),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ];

    return const SizedBox.shrink();

    // return Padding(
    //   padding: EdgeInsets.symmetric(
    //     horizontal: AppConstants.sidePadding,
    //     vertical: 8.w,
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       CustomContainer(
    //         backgroundColor: BGColors.shade500,
    //         padding: EdgeInsets.zero,
    //         showShadow: true,
    //         shadow: shadow,
    //         child: Row(
    //           children: List.generate(HomeConstants.nav1.length, (index) {
    //             final nav = HomeConstants.nav1[index];
    //             return _buildNavButton(
    //               nav,
    //               onTap: () => navNotifier.state = index,
    //               isSelected: navIndex == index,
    //             );
    //           }),
    //         ),
    //       ),
    //       CustomContainer(
    //         padding: EdgeInsets.zero,
    //         showShadow: true,
    //         shadow: shadow,
    //         child: _buildNavButton(
    //           HomeConstants.nav2[navIndex],
    //           onTap: () {
    //             final screenPath = HomeConstants.nav2[navIndex].screenPath;
    //             if (screenPath != null) {
    //               context.push(screenPath);
    //             }
    //           },
    //           color: PrimaryColors.shade100,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _buildNavButton(
    NavModel nav, {
    bool isSelected = false,
    VoidCallback? onTap,
    Color? color,
  }) {
    return CustomContainer(
      onTap: onTap,
      margin: color == null ? EdgeInsets.all(6.w) : null,
      padding: color == null ? EdgeInsets.all(12.w) : null,
      backgroundColor:
          color ?? (isSelected ? BGColors.shade50 : Colors.transparent),
      child: CustomImage(imageType: ImageType.svgLocal, imageUrl: nav.selectedIcon),
    );
  }
}
