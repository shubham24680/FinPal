import 'package:finpal/app/app.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifier);

    return Scaffold(
      appBar: customAppBar(context, title: "Profile"),
      body: profileState.when(
        data: (profile) {
          final values = {
            "full_name": profile.name,
            "date_of_birth": profile.dob,
            "gender": profile.gender,
            "monthly_income": ref.formatCurrency(profile.monthlyIncome),
          };

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppConstants.sidePadding,
              right: AppConstants.sidePadding,
              top: AppConstants.sidePadding,
              bottom: AppConstants.bottomPadding,
            ),
            child: Column(
              spacing: 16.spMin,
              children: [
                _buildViewProfile(context, profile),
                profileTiles(
                  context,
                  ProfileConstants.profileContents,
                  values,
                  title: "Personal Information",
                ),
              ],
            ),
          );
        },
        error:
            (_, __) => Center(
              child: CustomTypography(
                text: "Couldn't load profile",
                fontType: FontType.body1Medium,
                color: context.colors.onSurface,
              ),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildViewProfile(BuildContext context, ProfileModel profile) {
    final name = profile.name.isEmpty ? "Complete your profile" : profile.name;
    final profileDate =
        profile.createdAt?.formatDate(type: DateFormatType.monthYear) ?? "";
    final desc =
        profile.name.isEmpty
            ? "Add your details to personalize your experience"
            : "Member ${profileDate.isNotEmpty ? "since $profileDate" : ""}";

    return CustomContainer(
      backgroundColor: context.colors.surface,
      showShadow: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16.spMin,
        children: [
          Row(
            spacing: 12.spMin,
            children: [
              buildAvatar(
                context,
                name: profile.name,
                image: profile.profileImage,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2.spMin,
                  children: [
                    CustomTypography(
                      text: name,
                      fontType: FontType.body1Semibold,
                    ),
                    CustomTypography(
                      text: desc,
                      fontType: FontType.label1Medium,
                      color: context.colors.onSurfaceVariant,
                    ),
                  ],
                ),
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
