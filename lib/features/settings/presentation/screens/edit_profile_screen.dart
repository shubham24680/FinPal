import 'package:finpal/app/app.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPadding = AppConstants.sidePadding + context.viewInsets.bottom;
    final profileState = ref.watch(profileProvider);
    final profileNotifier = ref.watch(profileProvider.notifier);

    return Scaffold(
      appBar: customAppBar(context, title: "Edit Profile"),
      bottomNavigationBar: CustomButton(
        buttonState: profileState.buttonState,
        label: "Save Changes",
        onTap: () async {
          final hasSubmitted = await profileNotifier.onSubmit();
          if (hasSubmitted && context.mounted) {
            context.pop();
          }
        },
      ).padding(
        left: AppConstants.sidePadding,
        right: AppConstants.sidePadding,
        bottom: bottomPadding,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.sidePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfilePicture(context, profileState, profileNotifier),
            SizedBox(height: 32.spMin),
            CustomTypography(
              text: "Personal Information",
              fontType: FontType.body2Medium,
              color: context.colors.onSurface,
            ).padding(left: 8.r, bottom: 4.r),
            CustomContainer(child: PersonalDetailsForm()),
          ],
        ),
      ),
    ).onTap(event: () => FocusScope.of(context).unfocus());
  }

  Widget _buildProfilePicture(
    BuildContext context,
    ProfileState profileState,
    ProfileProvider profileNotifier,
  ) {
    final values = ProfileConstants.profileImageOptions;
    final options = ListView.separated(
      shrinkWrap: true,
      itemCount: values.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return CustomContainer(
          onTap: () async {
            final image = await ImagePicker().pickImage(
              source:
                  values[index].id == "camera"
                      ? ImageSource.camera
                      : ImageSource.gallery,
            );
            if (context.mounted) {
              context.pop();
            }
            profileNotifier.setProfileImage(image?.path);
          },
          padding: EdgeInsets.symmetric(vertical: 16.r),
          child: Row(
            spacing: 12.spMin,
            children: [
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: values[index].icon,
                color: values[index].iconColor,
              ),
              CustomTypography(
                text: values[index].title,
                fontType: FontType.body2Medium,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(),
    );
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          buildAvatar(
            context,
            size: 100.spMin,
            image: profileState.profileImage,
            enableBorder: true,
          ),
          CustomContainer(
            onTap: () => CustomBottomSheet.show(context, widget: options),
            backgroundColor: AppColors.primary500,
            padding: EdgeInsets.all(8.r),
            child: CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: AppSvgs.camera,
              color: context.colors.surface,
              height: 16.spMin,
              width: 16.spMin,
            ),
          ),
        ],
      ),
    );
  }
}
