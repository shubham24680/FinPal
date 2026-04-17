import 'package:finpal/app/app.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final imageUrl = AppImages.avatar[profileState.profilePicIndex];
    final bottomPadding =
        AppConstants.sidePadding + MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: customAppBar(context, title: "Edit Profile"),
      body: Center(
        child: Column(
          children: [
            CustomContainer(
              padding: EdgeInsets.all(2.w),
              borderRadius: BorderRadius.circular(1000.r),
              backgroundColor: CardColors.shade1000,
              height: 150.w,
              width: 150.w,
              child: ClipOval(
                child: CustomImage(
                  imageType: ImageType.local,
                  imageUrl: imageUrl,
                ),
              ),
            ),
            const Spacer(),
            profileState.tryEditing
                ? editData(profileState)
                : showData(profileState),
            const Spacer(flex: 4),
          ],
        ),
      ).padding(
        horizontal: AppConstants.sidePadding,
        vertical: 2 * AppConstants.sidePadding,
      ),
      bottomNavigationBar: buildButtons(
        context,
        ref,
        profileState,
      ).padding(bottom: bottomPadding, horizontal: AppConstants.sidePadding),
    ).onTap(event: () => FocusScope.of(context).unfocus());
  }

  Widget editData(ProfileState profileState) {
    return CustomTextField(
      controller: profileState.nameController,
      hintText: "Name",
    );
  }

  Widget showData(ProfileState profileState) {
    final name = profileState.name;
    return Column(
      children: [if (name != null && name.isNotEmpty) buildData("Name", name)],
    );
  }

  Widget buildButtons(
    BuildContext context,
    WidgetRef ref,
    ProfileState profileState,
  ) {
    final tryEditing = profileState.tryEditing;
    final profileController = ref.read(profileProvider.notifier);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tryEditing) ...[
            CustomButton(
              onTap: () => chooseAvatar(context, ref, profileState),
              label: "Choose your avatar",
              bgColor: BGColors.shade600,
              labelColor: TextColors.shade900,
            ),
            SizedBox(height: 8.w),
          ],
          CustomButton(
            onTap: () async {
              if (tryEditing) {
                await profileController.saveData();
              }
              profileController.toggle();
            },
            label: tryEditing ? "Save" : "Edit",
          ),
        ],
      ),
    );
  }

  void chooseAvatar(
    BuildContext context,
    WidgetRef ref,
    ProfileState profileState,
  ) {
    final child = GridView.builder(
      itemCount: AppImages.avatar.length,
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: AppConstants.sidePadding),
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 0.03.sh,
        crossAxisSpacing: 0.05.sw,
      ),
      itemBuilder: (context, index) {
        return CustomContainer(
          onTap: () {
            ref.read(profileProvider.notifier).setProfileIndexTo(index);
            context.pop();
          },
          backgroundColor:
              profileState.profilePicIndex == index
                  ? BGColors.shade700
                  : CardColors.shade1000,
          padding: EdgeInsets.all(2.w),
          borderRadius: BorderRadius.circular(1000.r),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1000.r),
            child: CustomImage(
              imageType: ImageType.local,
              imageUrl: AppImages.avatar[index],
            ),
          ),
        );
      },
    );

    customBottomSheet(context, "Choose your avatar", widget: child);
  }

  Widget buildData(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTypography(text: key, fontType: FontType.body1Semibold),
        CustomTypography(
          text: value,
          fontType: FontType.body1Semibold,
          color: BGColors.shade900,
        ),
      ],
    ).padding(vertical: 10.w);
  }
}
