import 'package:finpal/app/app.dart';

Future<OptionModel?> buildTranasactionBS(
  BuildContext context,
  List<OptionModel>? categories,
) async {
  final values = categories ?? [];
    final child = ListView.separated(
      shrinkWrap: true,
      itemCount: values.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final color = values[index].color.colorSet;

        return CustomContainer(
          onTap: () => context.pop(values[index]),
          padding: EdgeInsets.symmetric(vertical: 16.r),
          child: Row(
            spacing: 12.spMin,
            children: [
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: values[index].icon,
                color: color.normal,
              ),
              CustomTypography(
                text: values[index].name,
                fontType: FontType.body2Medium,
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(),
    );

  return await CustomBottomSheet.show(context, widget: child);
}
