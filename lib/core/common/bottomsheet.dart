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

  static Future<DateTime?> chooseDate(
    BuildContext context, {
    DateTime? date,
    DateTime? firstDate,
    DateTime? lastDate,
    bool showTime = false,
  }) async {
    final last = lastDate ?? DateTime.now();
    final picked = await show<DateTime>(
      context,
      title: showTime ? "Select date & time" : "Select date",
      widget: _DatePickerSheet(
        initialDate: date ?? last,
        firstDate: firstDate ?? DateTime(2026),
        lastDate: last,
        showTime: showTime,
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
    final bottomPadding = 16.r + context.buttonBottomPadding;

    return CustomContainer(
      backgroundColor: context.colors.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16.r,
          right: 16.r,
          top: 20.r,
          bottom: bottomPadding,
        ),
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
    this.showTime = false,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool showTime;

  @override
  State<_DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  static const double _wheelItemExtent = 40;
  static const double _wheelHeight = 160;

  late DateTime _selectedDate = widget.initialDate;

  late final FixedExtentScrollController _hourWheel =
      FixedExtentScrollController(initialItem: _hourIn12(_selectedDate) - 1);
  late final FixedExtentScrollController _minuteWheel =
      FixedExtentScrollController(initialItem: _selectedDate.minute);
  late final FixedExtentScrollController _meridiemWheel =
      FixedExtentScrollController(initialItem: _isAm ? 0 : 1);

  bool get _isAm => _selectedDate.hour < 12;

  static int _hourIn12(DateTime date) =>
      date.hour % 12 == 0 ? 12 : date.hour % 12;

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');

  @override
  void dispose() {
    _hourWheel.dispose();
    _minuteWheel.dispose();
    _meridiemWheel.dispose();
    super.dispose();
  }

  void _updateTime({int? hour, int? minute, bool? isAm}) {
    final hour12 = hour ?? _hourIn12(_selectedDate);
    final useAm = isAm ?? _isAm;

    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        (hour12 % 12) + (useAm ? 0 : 12),
        minute ?? _selectedDate.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCalendar(context),
        if (widget.showTime) _buildTimePicker(context),
        SizedBox(height: 16.spMin),
        CustomButton(
          onTap: () => context.pop(_selectedDate),
          prefixIcon: AppSvgs.calendar,
          label: "Save Date",
          buttonType: ButtonType.primary,
        ),
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return SizedBox(
      height: _wheelHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(children: List.generate(3, (index) => _buildWheelItem(context))),
          Row(
            children: [
              Expanded(
                child: _buildWheel(
                  context,
                  controller: _hourWheel,
                  itemCount: 12,
                  selectedItem: _hourIn12(_selectedDate) - 1,
                  labelBuilder: (index) => _twoDigits(index + 1),
                  onSelectedItemChanged:
                      (index) => _updateTime(hour: index + 1),
                ),
              ),
              CustomTypography(
                text: UnicodeConstants.colon,
                fontType: FontType.h4Semibold,
              ),
              Expanded(
                child: _buildWheel(
                  context,
                  controller: _minuteWheel,
                  itemCount: 60,
                  selectedItem: _selectedDate.minute,
                  labelBuilder: _twoDigits,
                  onSelectedItemChanged: (index) => _updateTime(minute: index),
                ),
              ),
              Expanded(
                child: _buildWheel(
                  context,
                  controller: _meridiemWheel,
                  itemCount: 2,
                  selectedItem: _isAm ? 0 : 1,
                  labelBuilder: (index) => index == 0 ? "AM" : "PM",
                  onSelectedItemChanged:
                      (index) => _updateTime(isAm: index == 0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWheelItem(BuildContext context) {
    return Flexible(
      child: Container(
        height: _wheelItemExtent,
        margin: EdgeInsets.symmetric(horizontal: 24.r),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  Widget _buildWheel(
    BuildContext context, {
    required FixedExtentScrollController controller,
    required int itemCount,
    required int selectedItem,
    required String Function(int index) labelBuilder,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: _wheelItemExtent,
      physics: const FixedExtentScrollPhysics(),
      diameterRatio: 1.5,
      overAndUnderCenterOpacity: 0.4,
      onSelectedItemChanged: onSelectedItemChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          final selected = index == selectedItem;
          return Center(
            child: CustomTypography(
              text: labelBuilder(index),
              fontType: selected ? FontType.h4Semibold : FontType.h4Regular,
              color:
                  selected ? context.colors.primary : context.colors.onSurface,
            ),
          );
        },
      ),
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
        onDateChanged:
            (date) => setState(() {
              _selectedDate =
                  widget.showTime
                      ? DateTime(
                        date.year,
                        date.month,
                        date.day,
                        _selectedDate.hour,
                        _selectedDate.minute,
                      )
                      : date;
            }),
      ),
    );
  }
}
