import 'package:finpal/app/app.dart';

enum TransactionAction { edit, delete }

class TransactionList extends ConsumerWidget {
  const TransactionList({
    super.key,
    required this.payments,
    this.label,
    this.labelColor,
    this.moreButtonLabel = "",
    this.onMoreButtonPressed,
    this.showDate = false,
  });

  final List<PaymentModel> payments;
  final String? label;
  final Color? labelColor;
  final String moreButtonLabel;
  final VoidCallback? onMoreButtonPressed;
  final bool showDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (payments.isEmpty) return const SizedBox.shrink();
    final date =
        label ?? payments.first.date.getDateLabel(type: DateFormatType.date1);
    final options = ref.watch(optionNotifer).value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.spMin,
      children: [
        if (date.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 8.spMin,
            children: [
              CustomTypography(
                text: date,
                fontType: FontType.body2Semibold,
                color: labelColor ?? context.colors.onSurface,
              ),
              if (moreButtonLabel.isNotEmpty)
                CustomTypography(
                  text: moreButtonLabel,
                  fontType: FontType.label1Medium,
                  color: context.colors.primary,
                  decoration: TextDecoration.underline,
                ).onTap(event: onMoreButtonPressed),
            ],
          ).padding(horizontal: 4.spMin),
        CustomContainer(
          backgroundColor: context.colors.surface,
          padding: EdgeInsets.zero,
          child: ListView.separated(
            itemCount: payments.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder:
                (context, index) => buildTransactionTile(
                  context,
                  ref,
                  payments[index],
                  options,
                  showDate: showDate,
                ),
            separatorBuilder: (context, index) => Divider(),
          ),
        ),
      ],
    ).padding(horizontal: AppConstants.sidePadding);
  }

  Widget buildTransactionTile(
    BuildContext context,
    WidgetRef ref,
    PaymentModel payment,
    OptionServices? options, {
    bool showDate = false,
  }) {
    final isDark = context.isDarkMode;
    final category = options?.findById(payment.categoryId);
    final color = category?.color.colorSet ?? ColorSet.primary;
    final title = payment.notes.isEmpty ? "Other" : payment.notes;
    final isExpense = payment.paymentType == TransactionType.expense.id;

    return Builder(
      builder: (tileContext) {
        return CustomContainer(
          onTap: () {
            CustomBottomSheet.show(
              context,
              widget: TransactionDetailBS(payment: payment),
              noPadding: true,
            );
          },
          onLongTap: () => _showActionsMenu(tileContext, ref, payment),
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: 16.spMin,
            vertical: 12.spMin,
          ),
          child: Row(
            spacing: 12.spMin,
            children: [
              if (category != null)
                CustomContainer(
                  padding: EdgeInsets.all(12.r),
                  backgroundColor: isDark ? color.dimDark : color.light,
                  child: CustomImage(
                    imageType: ImageType.svgLocal,
                    imageUrl: category.icon,
                    color: color.normal,
                    height: 16.spMin,
                    width: 16.spMin,
                  ),
                ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2.spMin,
                  children: [
                    CustomTypography(
                      text: title,
                      fontType: FontType.body2Medium,
                      maxLines: 1,
                    ),
                    if (category != null)
                      CustomTypography(
                        text: category.name,
                        fontType: FontType.label1Regular,
                        color: context.colors.onSurfaceVariant,
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 2.spMin,
                children: [
                  CustomTypography(
                    text: CurrencyFormatter.signed(
                      payment.amount,
                      isExpense: isExpense,
                    ),
                    fontType: FontType.body2Semibold,
                    color:
                        isExpense
                            ? context.colors.inverseSurface
                            : context.successColor,
                  ),
                  CustomTypography(
                    text: payment.date.formatDate(type: showDate ? DateFormatType.date1 : DateFormatType.time),
                    fontType: FontType.label1Medium,
                    color: context.colors.onSurface,
                  ),
                ],
              ),
              // CustomImage(
              //   imageType: ImageType.svgLocal,
              //   imageUrl: AppSvgs.arrowRight1,
              //   color: context.colors.onSurfaceVariant,
              //   height: 16.spMin,
              // ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showActionsMenu(
    BuildContext context,
    WidgetRef ref,
    PaymentModel payment,
  ) async {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final box = context.findRenderObject() as RenderBox;
    final topLeft = box.localToGlobal(Offset.zero, ancestor: overlay);

    final action = await showMenu<TransactionAction>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(
          topLeft.dx,
          topLeft.dy + box.size.height / 2,
          box.size.width,
          0,
        ),
        Offset.zero & overlay.size,
      ),
      color: context.colors.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      items: [
        _menuItem(
          context,
          value: TransactionAction.edit,
          label: "Edit",
          icon: AppSvgs.edit,
        ),
        _menuItem(
          context,
          value: TransactionAction.delete,
          label: "Delete",
          icon: AppSvgs.bin,
          color: context.colors.error,
        ),
      ],
    );

    if (!context.mounted || action == null) return;

    switch (action) {
      case TransactionAction.edit:
        openEdit(context, ref, payment);
      case TransactionAction.delete:
        confirmDelete(context, ref, payment);
    }
  }

  PopupMenuItem<TransactionAction> _menuItem(
    BuildContext context, {
    required TransactionAction value,
    required String label,
    required String icon,
    Color? color,
  }) {
    final itemColor = color ?? context.colors.onSurface;
    return PopupMenuItem(
      value: value,
      height: 40.spMin,
      child: Row(
        spacing: 12.spMin,
        children: [
          CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: icon,
            color: itemColor,
            height: 18.spMin,
            width: 18.spMin,
          ),
          CustomTypography(
            text: label,
            fontType: FontType.body2Semibold,
            color: itemColor,
          ),
        ],
      ),
    );
  }
}

void openEdit(BuildContext context, WidgetRef ref, PaymentModel payment) {
  ref.read(selectedTransactionProvider.notifier).state = payment;
  context.push(AppRoutesPath.editTransaction.path);
}

Future<bool?> confirmDelete(
  BuildContext context,
  WidgetRef ref,
  PaymentModel payment,
) {
  final isDark = context.isDarkMode;
  return CustomDialog.show(
    context,
    icon: AppSvgs.bin,
    iconColor: AppColors.error500,
    iconBgColor: isDark ? AppColors.error700.withAlpha(50) : AppColors.error50,
    title: "Delete Transaction",
    message: "You can't undo this. This transaction will be removed.",
    buttonText: "Yes, Delete",
    buttonColor: AppColors.error500,
    onPressed: () {
      ref.read(transactionProvider.notifier).deletePayment(payment.id);
      context.pop();
      context.showSnackBar("Transaction deleted successfully");
    },
  );
}
