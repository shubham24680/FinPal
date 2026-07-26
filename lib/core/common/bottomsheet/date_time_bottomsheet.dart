import 'package:finpal/app/app.dart';

class DatePickerSheet extends StatefulWidget {
  const DatePickerSheet({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.showTime = false,
    this.onlyMonths = false,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool showTime;
  final bool onlyMonths;

  @override
  State<DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<DatePickerSheet> {
  late DateTime _selectedDate = widget.initialDate;

  late final FixedExtentScrollController _monthWheel =
      FixedExtentScrollController(
        initialItem: _selectedDate.month - _minimumMonth(_selectedDate.year),
      );
  late final FixedExtentScrollController _yearWheel =
      FixedExtentScrollController(
        initialItem: _selectedDate.year - widget.firstDate.year,
      );
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

  int _minimumMonth(int year) =>
      year == widget.firstDate.year ? widget.firstDate.month : 1;

  int _maximumMonth(int year) =>
      year == widget.lastDate.year ? widget.lastDate.month : 12;

  @override
  void dispose() {
    _monthWheel.dispose();
    _yearWheel.dispose();
    _hourWheel.dispose();
    _minuteWheel.dispose();
    _meridiemWheel.dispose();
    super.dispose();
  }

  void _updateMonth({int? month, int? year}) {
    final selectedYear = year ?? _selectedDate.year;
    final minimumMonth = _minimumMonth(selectedYear);
    final maximumMonth = _maximumMonth(selectedYear);
    final selectedMonth = (month ?? _selectedDate.month).clamp(
      minimumMonth,
      maximumMonth,
    );
    final maximumDay = DateTime(selectedYear, selectedMonth + 1, 0).day;

    setState(() {
      _selectedDate = DateTime(
        selectedYear,
        selectedMonth,
        _selectedDate.day.clamp(1, maximumDay),
        _selectedDate.hour,
        _selectedDate.minute,
      );
    });

    if (year != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_monthWheel.hasClients) return;
        _monthWheel.jumpToItem(selectedMonth - minimumMonth);
      });
    }
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
    final label =
        widget.showTime
            ? "Save Date ${UnicodeConstants.and} Time"
            : widget.onlyMonths
            ? "Save Month"
            : "Save Date";
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.onlyMonths) _buildCalendar(context),
        if (widget.showTime) _buildTimePicker(context),
        if (widget.onlyMonths) _buildMonthsPicker(context),
        SizedBox(height: 16.spMin),
        CustomButton(
          onTap: () => context.pop(_selectedDate),
          prefixIcon: AppSvgs.calendar,
          label: label,
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

  Widget _buildMonthsPicker(BuildContext context, {double height = 160}) {
    final minimumMonth = _minimumMonth(_selectedDate.year);
    final maximumMonth = _maximumMonth(_selectedDate.year);

    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(children: List.generate(2, (index) => _buildWheelItem(context))),
          Row(
            children: [
              Expanded(
                child: _buildWheel(
                  context,
                  controller: _monthWheel,
                  itemCount: maximumMonth - minimumMonth + 1,
                  selectedItem: _selectedDate.month - minimumMonth,
                  labelBuilder:
                      (index) => DateTime(
                        2020,
                        minimumMonth + index,
                      ).formatDate(type: DateFormatType.month),
                  onSelectedItemChanged:
                      (index) => _updateMonth(month: minimumMonth + index),
                ),
              ),
              Expanded(
                child: _buildWheel(
                  context,
                  controller: _yearWheel,
                  itemCount: widget.lastDate.year - widget.firstDate.year + 1,
                  selectedItem: _selectedDate.year - widget.firstDate.year,
                  labelBuilder:
                      (index) => (widget.firstDate.year + index).toString(),
                  onSelectedItemChanged:
                      (index) =>
                          _updateMonth(year: widget.firstDate.year + index),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, {double height = 160}) {
    return SizedBox(
      height: height,
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

  Widget _buildWheelItem(BuildContext context, {double height = 40}) {
    return Flexible(
      child: Container(
        height: height,
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
    double itemExtent = 40,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: itemExtent,
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
}
