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
          try {
            final image = await ImagePicker().pickImage(
              source:
                  options[index].id == "camera"
                      ? ImageSource.camera
                      : ImageSource.gallery,
            );
            if (context.mounted) context.pop(image?.path);
          } catch (_) {
            if (context.mounted) {
              context.pop();
              context.showSnackBar(
                "Unable to access ${options[index].title.toLowerCase()}",
                toastType: ToastType.error,
              );
            }
          }
        },
        padding: EdgeInsets.symmetric(vertical: 16.r),
        child: Row(
          spacing: 12.spMin,
          children: [
            CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: options[index].icon,
              color: options[index].color.normal,
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
