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
    bool onlyMonths = false,
  }) async {
    final last = lastDate ?? DateTime.now();
    final title =
        showTime
            ? "Select ${onlyMonths ? "month" : "date"} ${UnicodeConstants.and} time"
            : "Select ${onlyMonths ? "month" : "date"}";
    final picked = await show<DateTime>(
      context,
      title: title,
      widget: DatePickerSheet(
        initialDate: date ?? last,
        firstDate: firstDate ?? DateTime(2020),
        lastDate: last,
        showTime: showTime,
        onlyMonths: onlyMonths,
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
