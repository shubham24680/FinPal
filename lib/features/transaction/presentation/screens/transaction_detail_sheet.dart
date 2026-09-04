import 'dart:io';

import 'package:finpal/app/app.dart';

class TransactionDetailBS extends ConsumerWidget {
  const TransactionDetailBS({super.key, required this.payment});

  final PaymentModel payment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDarkMode;
    final options = ref.watch(optionNotifer).value;
    final category =
        options?.findById(payment.categoryId) ?? OptionsConstant.otherCategory;
    final paymentMethod =
        options?.findById(payment.paymentMethodId) ??
        OptionsConstant.otherCategory;
    final color = category.color.colorSet;
    final type = payment.paymentType.type;
    final title = payment.notes.isEmpty ? category.name : payment.notes;
    final accent =
        type == TransactionType.expense ? ColorSet.error : ColorSet.primary;

    return CustomContainer(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          isDark ? accent.dimDark : accent.extraLight,
          context.colors.surface,
        ],
        stops: [0.0, 0.3],
      ),
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 20.spMin,
        children: [
          _buildHeader(context, ref, color, type, title, accent: accent),
          _buildSummary(context, category, paymentMethod, accent: accent),
          _buildDetails(
            context,
            type: type,
            paymentMethod: paymentMethod,
            note: payment.notes.isEmpty ? "—" : payment.notes,
            accent: accent,
          ),
          if (payment.receiptPath.isNotEmpty)
            _buildReceipt(context, payment.receiptPath),
          _buildActions(context, ref),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    ColorSet color,
    TransactionType type,
    String title, {
    ColorSet accent = ColorSet.purple,
  }) {
    final isExpense = type == TransactionType.expense;
    return Column(
      children: [
        CustomContainer(
          height: 88.spMin,
          width: 88.spMin,
          borderRadius: BorderRadius.circular(1000.r),
          backgroundColor: accent.normal,
          padding: EdgeInsets.all(24.r),
          alignment: Alignment.center,
          child: CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: type.icon,
            color: AppColors.white,
            height: 36.spMin,
            width: 36.spMin,
          ),
        ),
        SizedBox(height: 16.spMin),
        CustomTypography(
          text: isExpense ? "Money Spent" : "Money Received",
          fontType: FontType.label1Medium,
          color: accent.normal,
        ),
        SizedBox(height: 8.spMin),
        CustomTypography(
          text: title,
          fontType: FontType.h3Bold,
          align: TextAlign.center,
        ),
        CustomTypography(
          text: ref.formatSignedCurrency(
            payment.amount,
            isExpense: isExpense,
          ),
          fontType: FontType.h1Bold,
          align: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSummary(
    BuildContext context,
    OptionModel category,
    OptionModel paymentMethod, {
    ColorSet accent = ColorSet.purple,
  }) {
    return CustomContainer(
      backgroundColor: context.colors.surfaceContainerHighest,
      border: Border.all(color: context.colors.outlineVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.spMin,
        children: [
          _sectionHeader(
            context,
            icon: AppSvgs.calendar1,
            "Summary",
            accent: accent,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _summaryItem(
                  context,
                  icon: category.icon,
                  label: "Category",
                  value: category.name,
                  accent: accent,
                ),
              ),
              SizedBox(width: 12.spMin),
              Expanded(
                child: _summaryItem(
                  context,
                  icon: paymentMethod.icon,
                  label: "Payment method",
                  value: paymentMethod.name,
                  accent: accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
    BuildContext context, {
    ColorSet accent = ColorSet.purple,
    required String icon,
    required String label,
    required String value,
  }) {
    final isDark = context.isDarkMode;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.spMin,
      children: [
        CustomContainer(
          padding: EdgeInsets.all(10.r),
          backgroundColor: isDark ? accent.dimDark : accent.light,
          borderRadius: BorderRadius.circular(12.r),
          child: CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: icon,
            color: accent.normal,
            height: 18.spMin,
            width: 18.spMin,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.spMin,
            children: [
              CustomTypography(
                text: label,
                fontType: FontType.label1Medium,
                color: context.colors.onSurface,
              ),
              CustomTypography(
                text: value,
                fontType: FontType.body2Semibold,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(
    BuildContext context, {
    required TransactionType type,
    required OptionModel paymentMethod,
    required String note,
    ColorSet accent = ColorSet.purple,
  }) {
    final rows = [
      TransactionHelperModel(
        icon: AppSvgs.calendar1,
        label: "Date",
        value: payment.date.formatDate(type: DateFormatType.date1),
      ),
      TransactionHelperModel(
        icon: AppSvgs.time,
        label: "Time",
        value: payment.date.formatDate(type: DateFormatType.time),
      ),
      TransactionHelperModel(
        icon: type.icon,
        label: "Transaction Type",
        value: type.name,
      ),
      TransactionHelperModel(
        icon: paymentMethod.icon,
        label: "Payment Method",
        value: paymentMethod.name,
      ),
      TransactionHelperModel(icon: AppSvgs.edit1, label: "Note", value: note),
    ];

    return CustomContainer(
      backgroundColor: context.colors.surfaceContainerHighest,
      border: Border.all(color: context.colors.outlineVariant),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            context,
            "Transaction Details",
            icon: AppSvgs.category,
            accent: accent,
          ).padding(all: 16.spMin),
          ListView.separated(
            itemCount: rows.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => _detailRow(context, rows[index]),
            separatorBuilder: (context, index) => Divider(),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, TransactionHelperModel helper) {
    return Row(
      spacing: 4.spMin,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            spacing: 12.spMin,
            children: [
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: helper.icon,
                color: context.colors.onSurfaceVariant,
                height: 18.spMin,
                width: 18.spMin,
              ),
              Expanded(
                child: CustomTypography(
                  text: helper.label,
                  fontType: FontType.body2Medium,
                  color: context.colors.onSurface,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: CustomTypography(
            text: helper.value,
            fontType: FontType.body2Semibold,
            color: helper.valueColor,
            align: TextAlign.end,
            maxLines: 2,
          ),
        ),
      ],
    ).padding(horizontal: 16.spMin, vertical: 12.spMin);
  }

  Widget _buildReceipt(BuildContext context, String receiptPath) {
    return CustomContainer(
      backgroundColor: context.colors.surfaceContainerHighest,
      border: Border.all(color: context.colors.outlineVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.spMin,
        children: [
          _sectionHeader(
            context,
            "Receipt",
            icon: AppSvgs.bills,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Stack(
            alignment: Alignment.topRight,
            children: [
              Image.file(
                File(receiptPath),
                fit: BoxFit.cover,
                height: 160.spMin,
                width: double.infinity,
                errorBuilder:
                    (_, _, _) => CustomTypography(
                    text: ReceiptUtils.fileName(receiptPath),
                    fontType: FontType.body2Medium,
                  )
              ),
              CustomContainer(
                onTap: () => showReceiptPreview(context, receiptPath),
                margin: EdgeInsets.all(4.r),
                padding: EdgeInsets.all(4.r),
                borderRadius: BorderRadius.circular(8.r),
                backgroundColor: context.colors.inverseSurface.withAlpha(100),
                child: CustomImage(
                  imageType: ImageType.svgLocal,
                  imageUrl: AppSvgs.fullScreen,
                  color: context.colors.surface,
                ),
              ),
            ],
          ),
          ),
          CustomTypography(
            text: ReceiptUtils.fileName(receiptPath),
            fontType: FontType.label1Medium,
            color: context.colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    return Row(
      spacing: 12.spMin,
      children: [
        Expanded(
          child: CustomButton(
            label: "Edit",
            prefixIcon: AppSvgs.edit,
            buttonVariant: ButtonVariant.tertiary,
            isFull: true,
            onTap: () {
              context.pop();
              openEdit(context, ref, payment);
            },
          ),
        ),
        Expanded(
          child: CustomButton(
            label: "Delete",
            prefixIcon: AppSvgs.bin,
            buttonType: ButtonType.negative,
            isFull: true,
            onTap: () async {
              final result = await confirmDelete(context, ref, payment);
              if (result == true && context.mounted) {
                context.pop();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(
    BuildContext context,
    String title, {
    String? icon,
    ColorSet accent = ColorSet.purple,
  }) {
    return Row(
      spacing: 8.spMin,
      children: [
        if (icon != null)
          CustomImage(
            imageType: ImageType.svgLocal,
            imageUrl: icon,
            color: accent.normal,
            height: 18.spMin,
            width: 18.spMin,
          ),
        Expanded(
          child: CustomTypography(
            text: title,
            fontType: FontType.body2Semibold,
          ),
        ),
      ],
    );
  }
}
