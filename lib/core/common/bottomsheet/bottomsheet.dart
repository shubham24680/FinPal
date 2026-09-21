import 'dart:ui';
import 'package:finpal/app/app.dart';

enum BottomSheetType {
  dismissByCross,
  dismissByTapOutside,
  dismissByCrossOrTapOutside,
  noDismissible,
}

enum SheetLayout { standard, expandable }

extension on BottomSheetType {
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
    this.layout = SheetLayout.standard,
    this.title,
    this.child,
    this.noPadding = false,
  });

  final BottomSheetType type;
  final SheetLayout layout;
  final String? title;
  final Widget? child;
  final bool noPadding;

  static const double _radius = 16;
  static const double _horizontalPadding = 16;
  static const double _topPadding = 20;
  static const double _bottomPadding = 16;

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    Widget? child,
    BottomSheetType type = BottomSheetType.dismissByCrossOrTapOutside,
    SheetLayout layout = SheetLayout.standard,
    bool noPadding = false,
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
          (_) => CustomBottomSheet(
            type: type,
            layout: layout,
            title: title,
            noPadding: noPadding,
            child: child,
          ),
    );
  }

  static Future<DateTime?> chooseDate(
    BuildContext context, {
    DateTime? date,
    DateTime? firstDate,
    DateTime? lastDate,
    bool showTime = false,
    bool onlyMonths = false,
  }) async {
    final effectiveLastDate = lastDate ?? DateTime.now();
    final unit = onlyMonths ? "month" : "date";

    final picked = await show<DateTime>(
      context,
      title:
          showTime
              ? "Select $unit ${UnicodeConstants.and} time"
              : "Select $unit",
      child: DatePickerSheet(
        initialDate: date ?? effectiveLastDate,
        firstDate: firstDate ?? DateTime(2020),
        lastDate: effectiveLastDate,
        showTime: showTime,
        onlyMonths: onlyMonths,
      ),
    );

    return picked ?? date;
  }

  static Future<OptionModel?> showOptions(
    BuildContext context, {
    String? type,
    List<OptionModel> categories = const [],
    OptionModel? selectedOption,
    String? title,
    bool enableSearch = true,
    bool enableAddButton = true,
  }) async {
    final option = await show<OptionModel>(
      context,
      title: title,
      layout: SheetLayout.expandable,
      child: OptionsBottomSheet(
        categories: categories,
        type: type,
        selectedOption: selectedOption,
        enableSearch: enableSearch,
        enableAddButton: enableAddButton,
      ),
    );
    return option ?? selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (type.showCloseButton) _buildCloseButton(context),
        Flexible(child: _buildSheet(context)),
      ],
    );
  }

  Widget _buildSheet(BuildContext context) {
    return CustomContainer(
      backgroundColor: context.colors.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(_radius.r)),
      padding: EdgeInsets.zero,
      child: switch (layout) {
        SheetLayout.expandable => _buildExpandableBody(context),
        SheetLayout.standard => _buildScrollableBody(context),
      },
    );
  }

  Widget _buildScrollableBody(BuildContext context) {
    return SingleChildScrollView(
      padding: _contentPadding(
        bottom: _bottomPadding.r + context.buttonBottomPadding,
        respectNoPadding: true,
      ),
      child: _buildColumn(context, content: child ?? const SizedBox.shrink()),
    );
  }

  Widget _buildExpandableBody(BuildContext context) {
    return Padding(
      padding: _contentPadding(bottom: context.viewInsets.bottom),
      child: _buildColumn(
        context,
        content: Flexible(child: child ?? const SizedBox.shrink()),
      ),
    );
  }

  EdgeInsets _contentPadding({
    required double bottom,
    bool respectNoPadding = false,
  }) {
    if (respectNoPadding && noPadding) {
      return EdgeInsets.only(bottom: bottom);
    }
    return EdgeInsets.only(
      left: _horizontalPadding.r,
      right: _horizontalPadding.r,
      top: _topPadding.r,
      bottom: bottom,
    );
  }

  Widget _buildColumn(BuildContext context, {required Widget content}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8.spMin,
      children: [
        if (title != null) ...[
          CustomTypography(text: title, fontType: FontType.body1Medium),
          Divider(color: context.colors.outline),
        ],
        content,
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: CustomContainer(
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
      ),
    );
  }
}
