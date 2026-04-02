import 'package:finpal/app/app.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navIndex = ref.watch(navProvider);
    final navNotifier = ref.read(navProvider.notifier);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.sidePadding,
        vertical: 8.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomContainer(
            backgroundColor: BGColors.shade500,
            padding: EdgeInsets.zero,
            child: Row(
              children: List.generate(HomeConstants.navs.length, (index) {
                final nav = HomeConstants.navs[index];
                return _buildNavButton(
                  nav,
                  onTap: () => navNotifier.state = index,
                  isSelected: navIndex == index,
                );
              }),
            ),
          ),
          _buildNavButton(
            HomeConstants.addAmount,
            onTap: () => context.push('/add_amount'),
            color: PrimaryColors.shade100,
          ),
        ],
      ),
    );
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
      child: CustomImage(imageType: ImageType.svgLocal, imageUrl: nav.icon),
    );
  }
}
