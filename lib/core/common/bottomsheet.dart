import 'package:finpal/app/app.dart';

enum BottomSheetType {
  dismissByCross,
  dismissByTapOutside,
  dismissByCrossOrTapOutside,
  noDismissible,
}

extension BottomSheetTypeX on BottomSheetType {
  bool get showCloseButton =>
      this == BottomSheetType.dismissByCross ||
      this == BottomSheetType.dismissByCrossOrTapOutside;

  bool get barrierDismissible =>
      this == BottomSheetType.dismissByTapOutside ||
      this == BottomSheetType.dismissByCrossOrTapOutside;
}

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    this.type = BottomSheetType.dismissByCrossOrTapOutside,
    this.title,
    this.widget,
  });

  final BottomSheetType type;
  final String? title;
  final Widget? widget;

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    Widget? widget,
    BottomSheetType type = BottomSheetType.dismissByCrossOrTapOutside,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withAlpha(100),
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      isDismissible: type.barrierDismissible,
      builder:
          (_) => CustomBottomSheet(type: type, title: title, widget: widget),
    );
  }

  static Future<String> chooseDate(
    BuildContext context,
    String date, {
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final last = lastDate ?? DateTime.now();
    final picked = await show<String>(
      context,
      title: "Select date",
      widget: _DatePickerSheet(
        initialDate: date.isEmpty ? last : date.parseDate(type: DateFormatType.date1),
        firstDate: firstDate ?? DateTime(2026),
        lastDate: last,
      ),
    );
    return picked ?? date;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (type.showCloseButton) _closeButton(context),
          Flexible(child: _buildBody(context)),
        ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomContainer(
      backgroundColor: context.colors.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8.spMin,
          children: [
            if (title != null) ...[
              CustomTypography(text: title, fontType: FontType.body1Medium),
              Divider(color: context.colors.outline),
            ],
            Flexible(child: widget ?? const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return CustomContainer(
      onTap: () => context.pop(),
      margin: EdgeInsets.all(16.r),
      backgroundColor: context.colors.inverseSurface.withAlpha(50),
      borderRadius: BorderRadius.circular(1000.r),
      padding: EdgeInsets.all(8.r),
      child: CustomImage(
        imageType: ImageType.svgLocal,
        imageUrl: AppSvgs.cross,
        color: AppColors.lightSurface,
        height: 24.spMin,
        width: 24.spMin,
      ),
    );
  }
}

class _DatePickerSheet extends StatefulWidget {
  const _DatePickerSheet({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  late DateTime _selectedDate = widget.initialDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCalendar(context),
        CustomButton(
          onTap: () => context.pop(_selectedDate.formatDate(type: DateFormatType.date1)),
          prefixIcon: AppSvgs.calendar,
          label: "Save Date",
          buttonType: ButtonType.primary,
        ),
      ],
    );
  }

  Widget _buildCalendar(BuildContext context) {
    final textStyle = CustomTypography(
      fontType: FontType.body1Semibold,
    ).getTextStyle(context);

    return Theme(
      data: context.theme.copyWith(
        dividerColor: Colors.transparent,
        dividerTheme: const DividerThemeData(color: Colors.transparent),
        colorScheme: context.colors.copyWith(
          primary: context.colors.onSurface,
          onPrimary: context.colors.primary,
          onSurface: context.colors.onSurface,
        ),
        datePickerTheme: DatePickerThemeData(
          dayStyle: textStyle,
          weekdayStyle: textStyle,
          yearStyle: textStyle,
        ),
      ),
      child: CalendarDatePicker(
        initialDate: _selectedDate,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        onDateChanged: (date) => setState(() => _selectedDate = date),
      ),
    );
  }
}