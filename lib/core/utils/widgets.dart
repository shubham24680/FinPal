import 'package:finpal/app/app.dart';
import 'package:intl/intl.dart';

String formatCurrency(double? amount) {
  if (amount == null) return "₹0.00";
  return NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  ).format(amount);
}

enum DateFormatType { fullDate, shortDateWithTime, monthYear }

String formatDate(
  DateTime date, {
  DateFormatType type = DateFormatType.fullDate,
}) {
  switch (type) {
    case DateFormatType.shortDateWithTime:
      return DateFormat("MMM d, hh:mm a").format(date);
    case DateFormatType.monthYear:
      return DateFormat("MMM yy").format(date);
    default:
      return DateFormat("EE, MMM d, yyyy").format(date);
  }
}

DateTime parseDate(String date) {
  return DateFormat("EE, MMM d, yyyy").parse(date);
}

// Bottom Sheet
Future<T?> customBottomSheet<T>(
  BuildContext context,
  String title, {
  Widget? widget,
  Color? backgroundColor,
  List<OptionModel>? options,
  OptionModel? selectedOption,
  void Function(OptionModel)? onSelected,
}) {
  final sheet =
      (options != null && options.isNotEmpty)
          ? GridView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            padding: EdgeInsets.symmetric(vertical: 8.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4.w,
              crossAxisSpacing: 4.w,
            ),
            itemBuilder: (context, index) {
              final item = options[index];
              final isSelected = item == selectedOption;

              return CustomContainer(
                onTap: () {
                  onSelected?.call(item);
                  context.pop();
                },
                backgroundColor:
                    isSelected ? BGColors.shade600 : BGColors.shade500,
                padding: EdgeInsets.all(12.w),
                showShadow: isSelected,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.w,
                  children: [
                    CustomImage(
                      imageType: ImageType.svgLocal,
                      imageUrl: item.icon,
                      height: 24.w,
                    ),
                    CustomTypography(
                      text: item.name,
                      fontType: FontType.body2Regular,
                    ),
                  ],
                ),
              );
            },
          )
          : const SizedBox.shrink();
  final child = widget ?? sheet;
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withAlpha(100),
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    builder:
        (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomContainer(
              onTap: () => context.pop(),
              margin: EdgeInsets.all(16.w),
              backgroundColor: Colors.black.withAlpha(50),
              borderRadius: BorderRadius.circular(1000.r),
              padding: EdgeInsets.all(8.w),
              child: CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: AppSvgs.cross,
                color: Colors.white,
                height: 24.w,
                width: 24.w,
              ),
            ),
            Flexible(
              child: CustomContainer(
                backgroundColor: backgroundColor ?? BGColors.shade200,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTypography(
                      text: title,
                      fontType: FontType.body1Medium,
                      color: TextColors.shade900,
                    ),
                    Divider(color: BGColors.shade600),
                    Flexible(child: child),
                  ],
                ),
              ),
            ),
          ],
        ),
  );
}

// choose date
Future<String> chooseDate(BuildContext context, String date) async {
  final textStyle =
      CustomTypography(fontType: FontType.body1Semibold).getTextStyle();

  final firstDate = DateTime(2026);
  final lastDate = DateTime.now();
  final initialDate = parseDate(date);

  DateTime selectedDate = initialDate;

  final child = StatefulBuilder(
    builder: (context, setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              dividerTheme: DividerThemeData(color: Colors.transparent),
              colorScheme: ColorScheme.dark(
                primary: BGColors.shade700,
                onPrimary: PrimaryColors.shade500,
                onSurface: BGColors.shade800,
              ),
              datePickerTheme: DatePickerThemeData(
                dayStyle: textStyle,
                weekdayStyle: textStyle,
                yearStyle: textStyle,
              ),
            ),
            child: CalendarDatePicker(
              initialDate: selectedDate,
              firstDate: firstDate,
              lastDate: lastDate,
              onDateChanged: (DateTime date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
          ),
          CustomContainer(
            onTap: () => context.pop(formatDate(selectedDate)),
            backgroundColor: CardColors.shade1000,
            width: double.infinity,
            child: Row(
              spacing: 8.w,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImage(
                  imageType: ImageType.svgLocal,
                  imageUrl: AppSvgs.calendar,
                  color: Colors.white,
                ),
                CustomTypography(
                  text: "Save Date",
                  color: Colors.white,
                  fontType: FontType.body1Medium,
                ),
              ],
            ),
          ),
        ],
      );
    },
  );

  return await customBottomSheet<String>(
        context,
        "Select date",
        widget: child,
      ) ??
      date;
}

Future<void> hitUrl(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

Future<void> showToast(
  BuildContext context,
  String message, {
  Color? backgroundColor,
  Color? textColor,
}) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor ?? CardColors.shade1000,
      margin: EdgeInsets.all(16.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      content: CustomTypography(
        text: message,
        fontType: FontType.body2Regular,
        color: textColor ?? Colors.white,
      ),
    ),
  );
}
