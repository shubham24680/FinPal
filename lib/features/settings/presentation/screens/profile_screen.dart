import 'dart:developer';
import 'package:finpal/app/app.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifier);
    final topPadding = AppConstants.sidePadding;
    final bottomPadding =
        50.spMin + AppConstants.sidePadding + context.viewInsets.bottom;

    return Scaffold(
      appBar: customAppBar(context, title: "Profile"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppConstants.sidePadding,
          right: AppConstants.sidePadding,
          top: topPadding,
          bottom: bottomPadding,
        ),
        child: profileState.when(
          data: (profile) {
            final values = {
              "full_name": profile.name,
              "date_of_birth": profile.dob,
              "gender": profile.gender,
            };

            return Column(
              spacing: 16.spMin,
              children: [
                _buildViewProfile(context, profile),
                viewContents(
                  context,
                  ProfileConstants.profileContents,
                  values,
                  title: "Personal Information",
                ),
              ],
            );
          },
          error: (e, s) {
            log("error: ${e.toString()}");
            return Center(
              child: CustomTypography(
                text: "Something went wrong",
                fontType: FontType.body2Medium,
                color: context.colors.onSurface,
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget _buildViewProfile(BuildContext context, ProfileModel profile) {
    final name = profile.name;

    return CustomContainer(
      backgroundColor: context.colors.surface,
      showShadow: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16.spMin,
        children: [
          if (name.isNotEmpty)
            Row(
              spacing: 12.spMin,
              children: [
                buildAvatar(context, name: name, image: profile.profileImage),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTypography(text: name, fontType: FontType.h4Semibold),
                    CustomTypography(
                      text: "Member since June 2026",
                      fontType: FontType.body2Medium,
                      color: context.colors.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          CustomButton(
            label: "Edit Profile",
            onTap: () => context.push(AppRoutesPath.editProfile.path),
          ),
        ],
      ),
    );
  }
}
