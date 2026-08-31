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
    final ctaText = transactionState.id != null ? "Update" : "Add";
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
          label: ctaText,
          onTap: () => transactionNotifer.save(),
        ).padding(
          horizontal: AppConstants.sidePadding,
          top: 8.spMin,
          bottom: context.buttonBottomPadding,
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
                            context,
                            type,
                            transactionState.type,
                            transactionNotifer,
                          ),
                        )
                        .toList(),
              ),
            ),
            _buildAmountField(context, transactionState, transactionNotifer),
            _buildDateField(context, transactionState, transactionNotifer),
            _otherFields(context, transactionState, transactionNotifer),
            _buildReceiptField(context, transactionState, transactionNotifer),
          ],
        ),
      ),
    ).onTap(event: () => context.focusNode.unfocus());
  }

  Widget _buildPaymentType(
    BuildContext context,
    TransactionType type,
    TransactionType selectedType,
    PaymentProvider notifer,
  ) {
    final isSelected = selectedType.id == type.id;
    final isDark = context.isDarkMode;

    return Expanded(
      child: CustomContainer(
        onTap: () => notifer.set(type: type),
        backgroundColor:
            isSelected ? context.colors.surface : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 4.spMin,
          children: [
            CustomTypography(
              text: type.name,
              fontType: FontType.label1Bold,
              color:
                  isSelected
                      ? type.color.normal
                      : context.colors.inverseSurface,
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

  Widget _buildAmountField(
    BuildContext context,
    PaymentState state,
    PaymentProvider notifer,
  ) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 4.spMin,
            children: [
              CustomTypography(
                text: "Amount",
                fontType: FontType.label1Bold,
                color: context.colors.onSurface,
              ),
              CustomTypography(
                text: '\u002A', // *
                fontType: FontType.label1Bold,
                color: context.colors.error,
              ),
            ],
          ),
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

  Widget _buildDateField(
    BuildContext context,
    PaymentState transactionState,
    PaymentProvider notifer,
  ) {
    return CustomContainer(
      child: _buildField(
        context,
        "Date",
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

  Widget _otherFields(
    BuildContext context,
    PaymentState state,
    PaymentProvider notifer,
  ) {
    final categories = ref
        .watch(optionNotifer)
        .value
        ?.byType(state.type.optionType.id);
    final paymentMethod = ref.watch(optionNotifer).value?.paymentMethods;

    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField(
            context,
            "Category",
            state.category?.icon ?? AppSvgs.category,
            state.category?.name,
            () async {
              final picked = await CustomBottomSheet.showOptions(
                context,
                categories,
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
            context,
            "Payment Method",
            state.paymentMethod?.icon ?? AppSvgs.upi,
            state.paymentMethod?.name,
            () async {
              final picked = await CustomBottomSheet.showOptions(
                context,
                paymentMethod,
                title: "Select Payment Method",
                selectedOption: state.paymentMethod,
              );
              notifer.set(paymentMethod: picked);
            },
            hintText: "Select Payment Method",
            color: state.paymentMethod?.color.colorSet,
          ),
          SizedBox(height: 20.spMin),
          CustomTypography(
            text: "Description",
            fontType: FontType.label1Bold,
            color: context.colors.onSurface,
          ),
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
    BuildContext context,
    String title,
    String icon,
    String? value,
    VoidCallback onTap, {
    String hintText = "",
    bool isRequired = false,
    ColorSet? color,
  }) {
    return Column(
      spacing: 8.spMin,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 4.spMin,
          children: [
            CustomTypography(
              text: title,
              fontType: FontType.label1Bold,
              color: context.colors.onSurface,
            ),
            if (isRequired)
              CustomTypography(
                text: '\u002A', // *
                fontType: FontType.label1Medium,
                color: context.colors.error,
              ),
          ],
        ),
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

  Widget _buildReceiptField(
    BuildContext context,
    PaymentState state,
    PaymentProvider notifer,
  ) {
    final hasReceipt = state.receiptPath.isNotEmpty;

    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.spMin,
        children: [
          CustomTypography(
            text: "Add Receipt",
            fontType: FontType.label1Bold,
            color: context.colors.onSurface,
          ),
          if (hasReceipt)
            _buildSelectedReceipt(context, state.receiptPath, notifer)
          else
            _buildUploadReceipt(context, notifer),
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
                  text: "JPG, PNG or JPEG (Max. 5MB)",
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
