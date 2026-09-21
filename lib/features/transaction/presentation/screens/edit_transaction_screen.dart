import 'dart:io';
import 'package:finpal/app/app.dart';

class EditTransactionScreen extends ConsumerStatefulWidget {
  const EditTransactionScreen({super.key});

  @override
  ConsumerState<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState extends ConsumerState<EditTransactionScreen> {
  late TextEditingController amountController;
  late TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    final transactionState = ref.read(paymentProvider);
    amountController = TextEditingController(text: transactionState.amount);
    noteController = TextEditingController(text: transactionState.notes);
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(paymentProvider);
    final transactionNotifer = ref.read(paymentProvider.notifier);
    final title = "${transactionState.id != null ? "Edit" : "Add"} Transaction";

    ref.listen(paymentProvider, (previous, next) {
      if (next.toastMessage.isEmpty) return;

      context.showSnackBar(next.toastMessage, toastType: next.toastType);
      if (next.toastType != ToastType.error) {
        context.pop();
      }
      ref.read(paymentProvider.notifier).clearToast();
    });

    return Scaffold(
      extendBody: true,
      appBar: customAppBar(context, title: title),
      bottomNavigationBar: SafeArea(
        child: CustomButton(
          buttonState: transactionState.buttonState,
          label: title,
          onTap: () => transactionNotifer.save(),
          margin: EdgeInsets.fromLTRB(
            AppConstants.sidePadding,
            8.spMin,
            AppConstants.sidePadding,
            context.buttonBottomPadding,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppConstants.sidePadding,
          right: AppConstants.sidePadding,
          top: AppConstants.sidePadding,
          bottom: 150.spMin + context.viewInsets.bottom,
        ),
        child: Column(
          spacing: 16.spMin,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomContainer(
              backgroundColor: Colors.transparent,
              border: Border.all(color: context.colors.surface),
              padding: EdgeInsets.zero,
              child: Row(
                children:
                    TransactionType.values
                        .map(
                          (type) => _buildPaymentType(
                            type,
                            transactionState.type,
                            transactionNotifer,
                          ),
                        )
                        .toList(),
              ),
            ),
            _buildAmountField(transactionState, transactionNotifer),
            _buildRecurringField(transactionState, transactionNotifer),
            _buildDateField(transactionState, transactionNotifer),
            _otherFields(transactionState, transactionNotifer),
            _buildReceiptField(transactionState, transactionNotifer),
          ],
        ),
      ),
    ).onTap(event: () => context.focusNode.unfocus());
  }

  Widget _buildPaymentType(
    TransactionType type,
    TransactionType selectedType,
    PaymentProvider notifer,
  ) {
    final isSelected = selectedType.id == type.id;
    final isDark = context.isDarkMode;
    final backgroundColor =
        isSelected ? context.colors.surface : Colors.transparent;
    final textColor =
        isSelected ? type.color.normal : context.colors.inverseSurface;

    return Expanded(
      child: CustomContainer(
        onTap: () => notifer.set(type: type),
        backgroundColor: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 4.spMin,
          children: [
            CustomTypography(
              text: type.name,
              fontType: FontType.label1Bold,
              color: textColor,
            ),
            Container(
              width: 16.spMin,
              height: 16.spMin,
              padding: EdgeInsets.all(2.r),
              decoration: BoxDecoration(
                color: isDark ? type.color.dimDark : type.color.light,
                shape: BoxShape.circle,
              ),
              child: CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: type.icon,
                color: type.color.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField(PaymentState state, PaymentProvider notifer) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          transTitle(context, "Amount", isMandatory: true),
          CustomTextField(
            onChanged: (value) => notifer.set(amount: value),
            controller: amountController,
            inputType: InputType.amount,
            helperText: state.helperText,
            helperTextColor: state.helperTextColor.normal,
            isUnderLineBorder: true,
            fillColor: Colors.transparent,
            hintStyle: CustomTypography(
              fontType: FontType.h1Medium,
              color: context.colors.onSurface,
            ).getTextStyle(context),
            style: CustomTypography(
              fontType: FontType.h1Semibold,
            ).getTextStyle(context),
          ),
        ],
      ),
    );
  }

  Widget _buildRecurringField(PaymentState state, PaymentProvider notifer) {
    final bottomPadding = state.recurringPayment ? 16.spMin : 8.spMin;
    return CustomContainer(
      padding: EdgeInsets.fromLTRB(
        20.spMin,
        8.spMin,
        AppConstants.sidePadding,
        bottomPadding,
      ),
      onTap: () => notifer.set(recurringPayment: !state.recurringPayment),
      animateOnTap: false,
      child: Column(
        spacing: 16.spMin,
        children: [
          Row(
            spacing: 16.spMin,
            children: [
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: AppSvgs.sync,
                color: context.colors.primary,
              ),
              Expanded(
                child: CustomTypography(
                  text: "Recurring payment",
                  fontType: FontType.body1Medium,
                ),
              ),
              Switch(
                value: state.recurringPayment,
                onChanged:
                    (_) =>
                        notifer.set(recurringPayment: !state.recurringPayment),
              ),
            ],
          ),
          if (state.recurringPayment) ...[
            _buildField(AppSvgs.time, "Inverval", () async {
              final picked = await CustomBottomSheet.showOptions(
                context,
                categories: TransactionConstants.intervalOptions,
                selectedOption: state.interval,
                title: "Select Interval",
                enableSearch: false,
                enableAddButton: false,
              );
              notifer.set(interval: picked);
            }, subValue: state.interval?.name ?? ""),
            _buildField(AppSvgs.time1, "End repetition", () => {}),
          ],
        ],
      ),
    );
  }

  Widget _buildDateField(
    PaymentState transactionState,
    PaymentProvider notifer,
  ) {
    return CustomContainer(
      child: _buildField(
        title: "Date",
        AppSvgs.calendar,
        transactionState.date,
        () async {
          final picked = await CustomBottomSheet.chooseDate(
            context,
            date: transactionState.date.parseDate(
              type: DateFormatType.dateTime,
            ),
            showTime: true,
          );
          if (!mounted) return;
          notifer.set(date: picked);
        },
        isRequired: true,
      ),
    );
  }

  Widget _otherFields(PaymentState state, PaymentProvider notifer) {
    final categories = ref
        .watch(optionNotifer)
        .value
        ?.byTypeSorted(state.type.optionType.id);
    final paymentMethod = ref.watch(optionNotifer).value?.byTypeSorted(OptionType.paymentMethod.id);

    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField(
            title: "Category",
            state.category?.icon ?? AppSvgs.category,
            state.category?.name,
            () async {
              final picked = await CustomBottomSheet.showOptions(
                context,
                type: state.type.optionType.id,
                categories: categories ?? [],
                title: "Select Category",
                selectedOption: state.category,
              );
              notifer.set(category: picked);
            },
            hintText: "Select Category",
            color: state.category?.color.colorSet,
          ),
          SizedBox(height: 20.spMin),
          _buildField(
            title: "Payment Method",
            state.paymentMethod?.icon ?? AppSvgs.upi,
            state.paymentMethod?.name,
            () async {
              final picked = await CustomBottomSheet.showOptions(
                context,
                type: OptionType.paymentMethod.id,
                categories: paymentMethod ?? [],
                title: "Select Payment Method",
                selectedOption: state.paymentMethod,
              );
              notifer.set(paymentMethod: picked);
            },
            hintText: "Select Payment Method",
            color: state.paymentMethod?.color.colorSet,
          ),
          SizedBox(height: 20.spMin),
          transTitle(context, "Note"),
          SizedBox(height: 8.spMin),
          CustomTextField(
            controller: noteController,
            maxLines: 3,
            maxLength: 100,
            hintText: "Add a note...",
            onChanged: (value) => notifer.set(notes: value),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String icon,
    String? value,
    VoidCallback onTap, {
    String subValue = "",
    String title = "",
    String hintText = "",
    bool isRequired = false,
    ColorSet? color,
  }) {
    return Column(
      spacing: 8.spMin,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          transTitle(context, title, isMandatory: isRequired),
        AnimatedTap(
          onTap: onTap,
          child: Row(
            spacing: 16.spMin,
            children: [
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: icon,
                color: color?.normal ?? context.colors.primary,
              ),
              Expanded(
                child: CustomTypography(
                  text: value ?? hintText,
                  fontType: FontType.body1Medium,
                  color: (value != null) ? null : context.colors.onSurface,
                ),
              ),
              if (subValue.isNotEmpty)
                CustomTypography(
                  text: subValue,
                  fontType: FontType.label1Regular,
                  color: context.colors.onSurface,
                ),
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: AppSvgs.arrowRight1,
                color: context.colors.onSurface,
                width: 12.spMin,
                height: 12.spMin,
              ),
            ],
          ).padding(left: 4.spMin),
        ),
      ],
    );
  }

  Widget _buildReceiptField(PaymentState state, PaymentProvider notifer) {
    final hasReceipt = state.receiptPath.isNotEmpty;

    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.spMin,
        children: [
          transTitle(context, "Receipt"),
          hasReceipt
              ? _buildSelectedReceipt(context, state.receiptPath, notifer)
              : _buildUploadReceipt(context, notifer),
        ],
      ),
    );
  }

  Widget _buildUploadReceipt(BuildContext context, PaymentProvider notifer) {
    return AnimatedTap(
      onTap: () async {
        final image = await selectImageBottomSheet(context);
        if (image == null || !mounted) return;

        final receiptError = ReceiptUtils.validateReceipt(image);
        if (receiptError != null && context.mounted) {
          context.showSnackBar(receiptError, toastType: ToastType.error);
          return;
        }

        notifer.set(receiptPath: image);
      },
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: context.colors.outline,
          radius: 12.r,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 28.spMin,
              horizontal: 16.spMin,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImage(
                  imageType: ImageType.svgLocal,
                  imageUrl: AppSvgs.bills,
                  color: context.colors.primary,
                  height: 32.spMin,
                  width: 32.spMin,
                ),
                SizedBox(height: 12.spMin),
                CustomTypography(
                  text: "Upload Receipt",
                  fontType: FontType.body1Medium,
                  color: context.colors.onSurface,
                ),
                SizedBox(height: 4.spMin),
                CustomTypography(
                  text: "JPG or PNG (max 5MB)",
                  fontType: FontType.label1Medium,
                  color: context.colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedReceipt(
    BuildContext context,
    String path,
    PaymentProvider notifer,
  ) {
    final fileName = ReceiptUtils.fileName(path);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12.spMin,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Image.file(
                File(path),
                fit: BoxFit.cover,
                height: 160.spMin,
                width: double.infinity,
                errorBuilder:
                    (_, _, _) => CustomContainer(
                      backgroundColor: context.colors.surfaceContainerHighest,
                      padding: EdgeInsets.all(24.r),
                      child: CustomTypography(
                        text: "Unable to preview receipt",
                        fontType: FontType.body2Medium,
                        align: TextAlign.center,
                      ),
                    ),
              ),
              CustomContainer(
                onTap: () => showReceiptPreview(context, path),
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
        CustomContainer(
          backgroundColor: context.colors.surfaceContainerHighest,
          padding: EdgeInsets.all(12.r),
          child: Row(
            spacing: 12.spMin,
            children: [
              CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: AppSvgs.bills,
                color: context.colors.primary,
                height: 24.spMin,
                width: 24.spMin,
              ),
              Expanded(
                child: CustomTypography(
                  text: fileName,
                  fontType: FontType.body2Medium,
                  color: context.colors.onSurface,
                ),
              ),
              AnimatedTap(
                onTap: () => notifer.set(receiptPath: ''),
                child: CustomImage(
                  imageType: ImageType.svgLocal,
                  imageUrl: AppSvgs.cross,
                  color: context.colors.onSurfaceVariant,
                  height: 16.spMin,
                  width: 16.spMin,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
