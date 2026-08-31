import 'package:finpal/app/app.dart';

enum BottomSheetType {
  dismissByCross,
  dismissByTapOutside,
  dismissByCrossOrTapOutside,
  noDismissible,
}

enum SheetLayout { typeA, typeB }

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
    this.layout = SheetLayout.typeA,
    this.title,
    this.widget,
    this.noPadding = false,
  });

  final BottomSheetType type;
  final SheetLayout layout;
  final String? title;
  final Widget? widget;
  final bool noPadding;

  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    Widget? widget,
    BottomSheetType type = BottomSheetType.dismissByCrossOrTapOutside,
    SheetLayout layout = SheetLayout.typeA,
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
            widget: widget,
            noPadding: noPadding,
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

  static Future<OptionModel?> showOptions(
    BuildContext context,
    List<OptionModel>? options, {
    OptionModel? selectedOption,
    String? title,
  }) async {
    final option = await show<OptionModel>(
      context,
      title: title,
      widget: OptionsBottomSheet(options ?? const [], selectedOption: selectedOption),
      layout: SheetLayout.typeB,
    );
    return option ?? selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (type.showCloseButton) closeButton(context),
        Flexible(child: buildMainWidget(context)),
      ],
    );
  }

  Widget buildMainWidget(BuildContext context) {
    return CustomContainer(
      backgroundColor: context.colors.surface,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      padding: EdgeInsets.zero,
      child: switch (layout) {
        SheetLayout.typeB => typeBLayout(context),
        _ => defaultLayout(context),
      },
    );
  }

  List<Widget> headers(BuildContext context) {
    if (title == null) return const [];
    return [
      CustomTypography(text: title, fontType: FontType.body1Medium),
      Divider(color: context.colors.outline),
    ];
  }

  Widget defaultLayout(BuildContext context) {
    final bottomPadding = 16.r + context.buttonBottomPadding;
    return SingleChildScrollView(
      padding:
          noPadding
              ? EdgeInsets.only(bottom: bottomPadding)
              : EdgeInsets.only(
                left: 16.r,
                right: 16.r,
                top: 20.r,
                bottom: bottomPadding,
              ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.spMin,
        children: [...headers(context), widget ?? const SizedBox.shrink()],
      ),
    );
  }

  Widget typeBLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.r,
        right: 16.r,
        top: 20.r,
        bottom: context.viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.spMin,
        children: [
          ...headers(context),
          Flexible(child: widget ?? const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget closeButton(BuildContext context) {
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
