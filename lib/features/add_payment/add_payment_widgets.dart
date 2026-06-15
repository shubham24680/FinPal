import 'package:finpal/app/app.dart';

Widget buildBalance({double balance = 0.0}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    spacing: 4.w,
    children: [
      CustomTypography(text: "Total Balance", fontType: FontType.label1Light),
      CustomTypography(
        text: CurrencyFormatter.format(balance),
        fontType: FontType.h2Semibold,
      ),
    ],
  );
}

Widget buildAmountCard(
  BuildContext context, {
  required TextEditingController controller,
  required String date,
  String title = "Enter Amount",
  Color? backgroundColor,
  Color? color,
  void Function(String)? onDateSelected,
  void Function(String?)? onChanged,
  String? errorText,
}) {
  return CustomContainer(
    showShadow: true,
    backgroundColor: backgroundColor,
    child: Column(
      children: [
        CustomTypography(text: title, fontType: FontType.body2Regular),
        SizedBox(height: 12.w),
        CustomTextField(
          controller: controller,
          inputType: InputType.amount,
          focusedBorderColor: color,
          errorText: errorText,
          onChanged: (value) => onChanged?.call(value),
        ).padding(horizontal: 64.w),
        SizedBox(height: 24.w),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4.w,
          children: [
            CustomImage(
              imageType: ImageType.svgLocal,
              imageUrl: AppSvgs.calendar,
              height: 12.w,
            ),
            CustomTypography(text: date, fontType: FontType.label1Regular),
          ],
        ).onTap(
          event:
              () async => onDateSelected?.call(await chooseDate(context, date)),
        ),
      ],
    ),
  );
}

Widget buildCategoryTile(
  BuildContext context,
  String title,
  List<OptionModel> categories, {
  OptionModel? category,
  void Function(OptionModel)? onSelected,
}) {
  final suffixItem =
      category != null
          ? Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4.w,
            children: [
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: category.icon,
                height: 16.w,
              ),
              CustomTypography(
                text: category.name,
                fontType: FontType.body2Regular,
              ),
            ],
          )
          : CustomImage(imageType: ImageType.svgLocal, imageUrl: AppSvgs.add);

  return CustomContainer(
    backgroundColor: BGColors.shade500,
    padding: EdgeInsets.only(left: 16.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomTypography(text: title, fontType: FontType.body2Medium),
        CustomContainer(
          backgroundColor: BGColors.shade50,
          margin: EdgeInsets.all(8.w),
          padding: EdgeInsets.all(12.w),
          onTap:
              () => customBottomSheet(
                context,
                title,
                options: categories,
                selectedOption: category,
                onSelected: onSelected,
              ),
          child: suffixItem,
        ),
      ],
    ),
  );
}

Widget addNotes(TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomTypography(
        text: "Notes",
        fontType: FontType.body2Semibold,
      ).padding(left: 8.w),
      SizedBox(height: 8.w),
      CustomTextField(controller: controller, hintText: "Add Notes"),
    ],
  );
}
