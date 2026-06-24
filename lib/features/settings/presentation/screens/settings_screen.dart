import 'package:finpal/app/app.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPadding = AppConstants.sidePadding + context.viewPadding.top;
    final bottomPadding =
        50.spMin + AppConstants.sidePadding + context.viewInsets.bottom;

    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          CustomImage(
            imageUrl:
                context.isDarkMode ? AppImages.bannerDark : AppImages.banner,
            fit: BoxFit.fitWidth,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16.spMin,
            children: [
              CustomTypography(text: "Settings", fontType: FontType.h1Bold),
              CustomTypography(
                text: "Manage your preferences\nand account settings",
                fontType: FontType.body2Medium,
                color: context.colors.onSurface,
              ),
              _buildViewProfile(context, ref),
            ],
          ).padding(
            left: AppConstants.sidePadding,
            right: AppConstants.sidePadding,
            top: topPadding,
            bottom: bottomPadding,
          ),
        ],
      ),
    );
  }

  Widget _buildViewProfile(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifier);
    final profile = profileState.value;

    if (profile == null) {
      return CustomButton(
            label: "Edit Profile",
            onTap: () => context.push(AppRoutesPath.editProfile.path),
          );
    }

    return CustomContainer(
      onTap: () => context.push(AppRoutesPath.profile.path),
      backgroundColor: context.colors.surface,
      showShadow: true,
      child: Row(
        spacing: 12.spMin,
        children: [
          buildAvatar(context, name: profile.name, image: profile.profileImage),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTypography(text: profile.name, fontType: FontType.body1Semibold),
              CustomTypography(
                text: "View profile",
                fontType: FontType.body2Medium,
                color: context.colors.onSurfaceVariant,
              ),
            ],
          ),
          const Spacer(),
          CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: AppSvgs.arrowRight1,
            color: context.colors.onSurfaceVariant,
            height: 16.spMin,
          ),
        ],
      ),
    );
  }
}
