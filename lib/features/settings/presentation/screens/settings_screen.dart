import 'package:finpal/app/app.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 180.spMin),
      child: Column(
        spacing: 16.spMin,
        children: [
          _buildTopWidget(context, ref),
          Column(
            spacing: 16.spMin,
            children: [
              SettingsTiles(contents: SettingsConstants.accountContents, title: "ACCOUNT"),
              SettingsTiles(contents: SettingsConstants.appearanceContents, title: "APPEARANCE"),
              SettingsTiles(contents: SettingsConstants.preferencesContents, title: "PREFERENCES"),
              SettingsTiles(contents: SettingsConstants.dataContents, title: "DATA"),
              SettingsTiles(contents: SettingsConstants.aboutContents, title: "ABOUT & SUPPORT"),
            ],
          ).padding(horizontal: AppConstants.sidePadding)
        ],
      )
    );
  }

  Widget _buildTopWidget(BuildContext context, WidgetRef ref) {
    final topPadding = AppConstants.sidePadding + context.viewPadding.top;

    return SizedBox(
      height: 310.spMin,
      child: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          CustomImage(
            imageUrl:
                context.isDarkMode ? AppImages.bannerDark : AppImages.banner,
          ).padding(bottom: 44.spMin),
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
              Spacer(),
              _buildViewProfile(context, ref),
            ],
          ).padding(
            left: AppConstants.sidePadding,
            right: AppConstants.sidePadding,
            top: topPadding,
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

    final name = profile.name.isEmpty ? "Complete your profile" : profile.name;
    final desc =
        profile.name.isEmpty
            ? "Add your details to personalize your experience"
            : "View profile";

    return CustomContainer(
      onTap: () => context.push(AppRoutesPath.profile.path),
      backgroundColor: context.colors.surface,
      showShadow: true,
      child: Row(
        spacing: 12.spMin,
        children: [
          buildAvatar(context, name: profile.name, image: profile.profileImage),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2.spMin,
              children: [
                CustomTypography(text: name, fontType: FontType.body1Semibold),
                CustomTypography(
                  text: desc,
                  fontType: FontType.label1Medium,
                  color: context.colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
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
