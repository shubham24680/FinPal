import 'package:finpal/app/app.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final name = profileState.name;
    final imageUrl = AppImages.avatar[0];
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
        child: Column(children: [_buildViewProfile(context)]),
      ),
    );

    // return SingleChildScrollView(
    //   padding: EdgeInsets.only(
    //     left: AppConstants.sidePadding,
    //     right: AppConstants.sidePadding,
    //     top: topPadding,
    //     bottom: bottomPadding,
    //   ),
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     spacing: 16.w,
    //     children: [
    //       CustomTypography(text: "Profile", fontType: FontType.h1Bold),
    //       Column(
    //         spacing: 8.w,
    //         children: [
    //           CustomContainer(
    //             padding: EdgeInsets.all(2.w),
    //             borderRadius: BorderRadius.circular(1000.r),
    //             backgroundColor: CardColors.shade1000,
    //             height: 120.w,
    //             width: 120.w,
    //             child: ClipOval(
    //               child: CustomImage(
    //                 imageType: ImageType.local,
    //                 imageUrl: imageUrl,
    //               ),
    //             ),
    //           ),
    //           if (name != null && name.isNotEmpty)
    //             CustomTypography(text: name, fontType: FontType.body1Semibold),
    //         ],
    //       ),
    //       _buildButtons(context, false),
    //       _contents(context, profileState),
    //     ],
    //   ),
    // );
  }

  Widget _buildViewProfile(BuildContext context) {
    final name = "Shubham Patel";
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
              buildAvatar(context, name: name),
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

  Widget _buildButtons(BuildContext context, bool isUserActive) {
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

  Widget _contents(BuildContext context, ProfileState profileState) {
    return ListView.separated(
      itemCount: ProfileConstants.contentList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 16.w),
      itemBuilder: (_, index) {
        final content = ProfileConstants.contentList[index];
        final screenPath = content.screenPath;
        final icon = content.icon;
        final title = content.title;

        final child = SizedBox(
          height: 0.07.sh,
          child: Row(
            spacing: 16.w,
            children: [
              if (icon != null)
                CustomImage(
                  imageType: ImageType.svgLocal,
                  imageUrl: icon,
                  height: 24.w,
                  color: BGColors.shade900,
                ),
              if (title != null)
                Expanded(
                  child: CustomTypography(
                    text: title,
                    fontType: FontType.body2Medium,
                  ),
                ),
              _buildAction(content.action),
            ],
          ),
        );

        if (content.action == ProfileAction.navigate) {
          return InkWell(
            onTap: () {
              if (screenPath != null) {
                if (content.pathType == PathType.urlPath) {
                  hitUrl(screenPath);
                } else {
                  context.push(screenPath, extra: content.extra);
                }
              }
            },
            child: child,
          );
        }

        return child;
      },
      separatorBuilder:
          (_, index) => Divider(color: BGColors.shade700, height: 0),
    );
  }

  Widget _buildAction(ProfileAction action) {
    return switch (action) {
      ProfileAction.toggle => const FingerprintWidget(),
      _ => CustomImage(
        imageType: ImageType.svgLocal,
        imageUrl: AppSvgs.arrowRight,
        height: 16.w,
      ),
    };
  }
}
