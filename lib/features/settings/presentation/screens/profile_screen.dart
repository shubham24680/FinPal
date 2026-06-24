import 'dart:developer';
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
              const Spacer(),
              CustomButton(
                prefixIcon: AppSvgs.other,
                label: "Clear Data",
                buttonType: ButtonType.negative,
                buttonVariant: ButtonVariant.tertiary,
                onTap:
                    () => CustomDialog.show(
                      context,
                      title: "Confirm Clear Data",
                      message:
                          "This will permanently delete all your data from Finpal. This action cannot be undone.",
                      buttonText: "Clear All Data",
                      buttonColor: AppColors.error500,
                      onPressed: () {},
                    ),
              ),
            ],
          ).padding(
            horizontal: AppConstants.sidePadding,
            top: AppConstants.sidePadding,
            bottom: 28.r,
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
