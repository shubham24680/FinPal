import 'package:finpal/app/app.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding =
        AppConstants.sidePadding + MediaQuery.of(context).padding.top;
    final bottomPadding =
        AppConstants.sidePadding + MediaQuery.of(context).padding.bottom;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16.w,
      children: [
        CustomTypography(text: "Profile", fontType: FontType.h1Bold),
        Consumer(
          builder: (_, ref, __) {
            final profile = ref.watch(profileNotifier);
            final name = profile.value?.name;
            final index = profile.value?.profileImageIndex;
            final imageUrl = AppImages.avatar[index ?? 0];

            return Column(
              spacing: 8.w,
              children: [
                CustomContainer(
                  padding: EdgeInsets.all(2.w),
                  borderRadius: BorderRadius.circular(1000.r),
                  backgroundColor: CardColors.shade1000,
                  height: 120.w,
                  width: 120.w,
                  child: ClipOval(
                    child: CustomImage(
                      imageType: ImageType.local,
                      imageUrl: imageUrl,
                    ),
                  ),
                ),
                if (name != null && name.isNotEmpty)
                  CustomTypography(
                    text: name,
                    fontType: FontType.body1Semibold,
                  ),
              ],
            );
          },
        ),
        buildButtons(context, false),
        contents(context),
      ],
    ).padding(
      horizontal: AppConstants.sidePadding,
      top: topPadding,
      bottom: bottomPadding,
    );
  }

  Widget buildButtons(BuildContext context, bool isUserActive) {
    final editButton = CustomButton(
      onTap: () => context.push("/edit_profile"),
      label: "Edit Profile",
    );
    final logOutButton = CustomButton(
      onTap: () {},
      label: "Log Out",
      buttonType: ButtonType.negative,
    );

    return isUserActive
        ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: editButton),
            SizedBox(width: 8.w),
            Expanded(child: logOutButton),
          ],
        )
        : editButton;
  }

  Widget contents(BuildContext context) {
    return ListView.separated(
      itemCount: ProfileConstants.contentList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 32.w),
      itemBuilder: (_, index) {
        final content = ProfileConstants.contentList[index];

        return InkWell(
          onTap: () {
            if (content.screenPath != null) context.push(content.screenPath!);
          },
          child: SizedBox(
            height: 0.07.sh,
            child: Row(
              spacing: 16.w,
              children: [
                CustomImage(
                  imageType: ImageType.svgLocal,
                  imageUrl: content.icon,
                  height: 24.w,
                  color: BGColors.shade900,
                ),
                Expanded(
                  child: CustomTypography(
                    text: content.name,
                    fontType: FontType.body1Medium,
                  ),
                ),
                CustomImage(
                  imageType: ImageType.svgLocal,
                  imageUrl: AppSvgs.arrowRight,
                  height: 16.w,
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder:
          (_, index) => Divider(color: BGColors.shade700, height: 0),
    );
  }
}
