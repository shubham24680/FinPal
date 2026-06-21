import 'package:finpal/app/app.dart';

Widget buildAvatar(BuildContext context, {String? image, String? name}) {
    final initials = name?.split(' ').map((e) => e[0]).join('');
    final child =
        initials != null
            ? CustomTypography(
              text: initials,
              fontType: FontType.h2Semibold,
              color: AppColors.primary500,
            )
            : CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: AppSvgs.user1,
              color: AppColors.primary500,
            );
    return CustomContainer(
      borderRadius: BorderRadius.circular(1000.r),
      height: 60.r,
      width: 60.r,
      padding: EdgeInsets.all(8.r),
      backgroundColor: AppColors.primary50,
      alignment: Alignment.center,
      child: child,
    );
  }