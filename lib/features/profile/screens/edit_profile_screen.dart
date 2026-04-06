import 'package:finpal/app/app.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  static final _padding = AppConstants.sidePadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final profileController = ref.read(profileProvider.notifier);
    final bottomPadding = _padding + MediaQuery.of(context).viewInsets.bottom;

    void chooseAvatar() {
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
              profileController.setProfileIndexTo(index);
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

    Widget editData() {
      return CustomTextField(
        controller: profileState.nameController,
        hintText: "Name",
      );
    }

    Widget showData() {
      final name = profileState.name;
      return (profileState.tryEditing)
          ? editData()
          : Column(
            children: [
              if (name != null && name.isNotEmpty) buildData("Name", name),
            ],
          );
    }

    Widget bottomButton() => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (profileState.tryEditing) ...[
            CustomButton(
              onTap: chooseAvatar,
              label: "Choose your avatar",
              bgColor: BGColors.shade600,
              labelColor: TextColors.shade900,
            ),
            SizedBox(height: 8.w),
          ],
          CustomButton(
            onTap: () {
              if (profileState.tryEditing) {
                profileController.saveData();
              } else {
                profileController.loadField();
              }
              profileController.toggle();
            },
            label: profileState.tryEditing ? "Save" : "Edit",
          ),
        ],
      ).padding(horizontal: _padding, bottom: bottomPadding),
    );

    final imageUrl = AppImages.avatar[profileState.profilePicIndex];
    return Scaffold(
      appBar: customAppBar(context, "Edit Profile"),
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
            showData(),
            const Spacer(flex: 4),
          ],
        ),
      ).padding(horizontal: _padding, vertical: 2 * _padding),
      bottomNavigationBar: bottomButton(),
    ).onTap(event: () => FocusScope.of(context).unfocus());
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
