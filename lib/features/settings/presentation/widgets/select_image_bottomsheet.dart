import 'package:finpal/app/app.dart';

Future<String?> selectImageBottomSheet(BuildContext context) async {
  final options = ProfileConstants.profileImageOptions;
  final child = ListView.separated(
    shrinkWrap: true,
    itemCount: options.length,
    padding: EdgeInsets.zero,
    itemBuilder: (context, index) {
      return CustomContainer(
        onTap: () async {
          final image = await ImagePicker().pickImage(
            source:
                options[index].id == "camera"
                    ? ImageSource.camera
                    : ImageSource.gallery,
          );
          if (context.mounted) context.pop(image?.path);
        },
        padding: EdgeInsets.symmetric(vertical: 16.r),
        child: Row(
          spacing: 12.spMin,
          children: [
            CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: options[index].icon,
              color: options[index].iconColor,
            ),
            CustomTypography(
              text: options[index].title,
              fontType: FontType.body2Medium,
            ),
          ],
        ),
      );
    },
    separatorBuilder: (context, index) => const Divider(),
  );

  return await CustomBottomSheet.show<String?>(context, widget: child);
}
