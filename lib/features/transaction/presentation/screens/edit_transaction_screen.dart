import 'package:finpal/app/app.dart';

class EditTransactionScreen extends StatefulWidget {
  const EditTransactionScreen({super.key});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late TextEditingController amountController;
  late TextEditingController noteController;
  late String selectedDate;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
    selectedDate = DateTime.now().formatDate(type: DateFormatType.date1);
    noteController = TextEditingController();
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = "Add Transaction";
    final bottomPadding = 8.spMin + context.viewInsets.bottom;

    return Scaffold(
      extendBody: true,
      appBar: customAppBar(context, title: title),
      bottomNavigationBar: SafeArea(
        child: CustomButton(label: "Add", onTap: () {}).padding(
          horizontal: AppConstants.sidePadding,
          top: 8.spMin,
          bottom: bottomPadding,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.sidePadding),
        child: Column(
          spacing: 16.spMin,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomContainer(
              backgroundColor: Colors.transparent,
              border: Border.all(color: context.colors.surface),
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  _buildPaymentType(
                    context,
                    "Expense",
                    AppSvgs.arrowDown,
                    ColorSet.error,
                    isSelected: true,
                  ),
                  _buildPaymentType(
                    context,
                    "Income",
                    AppSvgs.arrowUp,
                    ColorSet.primary,
                  ),
                ],
              ),
            ),
            _buildAmountField(context, amountController),
            _buildDateField(context),
            _otherFields(context),
          ],
        ),
      ),
    ).onTap(event: () => context.focusNode.unfocus());
  }

  Widget _buildPaymentType(
    BuildContext context,
    String title,
    String icon,
    ColorSet color, {
    bool isSelected = false,
  }) {
    final isDark = context.isDarkMode;
    return Expanded(
      child: CustomContainer(
        backgroundColor:
            isSelected ? context.colors.surface : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 4.spMin,
          children: [
            CustomTypography(
              text: title,
              fontType: FontType.label1Bold,
              color: isSelected ? color.normal : context.colors.inverseSurface,
            ),
            Container(
              width: 16.spMin,
              height: 16.spMin,
              padding: EdgeInsets.all(2.r),
              decoration: BoxDecoration(
                color: isDark ? color.dimDark : color.light,
                shape: BoxShape.circle,
              ),
              child: CustomImage(
                imageType: ImageType.svgLocal,
                imageUrl: icon,
                color: color.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField(
    BuildContext context,
    TextEditingController controller,
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
            controller: controller,
            inputType: InputType.amount,
            helperText: "Change the amount of your transaction",
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

  Widget _buildDateField(BuildContext context) {
    return CustomContainer(
      child: _buildField(
        context,
        "Date",
        AppSvgs.calendar,
        selectedDate,
        () async {
          final picked = await CustomBottomSheet.chooseDate(
            context,
            selectedDate,
          );
          if (!mounted) return;
          setState(() => selectedDate = picked);
        },
        isSelected: true,
        isRequired: true,
      ),
    );
  }

  Widget _otherFields(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildField(
            context,
            "Category",
            AppSvgs.category,
            "Select Category",
            () async {
              await CustomBottomSheet.show(context);
            },
          ),
          SizedBox(height: 20.spMin),
          _buildField(
            context,
            "Payment Method",
            AppSvgs.upi,
            "Select Payment Method",
            () async {
              await CustomBottomSheet.show(context);
            },
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
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    BuildContext context,
    String title,
    String icon,
    String value,
    VoidCallback onTap, {
    bool isSelected = false,
    bool isRequired = false,
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
                fontType: FontType.label1Bold,
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
                color: context.colors.primary,
              ),
              Expanded(
                child: CustomTypography(
                  text: value,
                  fontType: FontType.body1Medium,
                  color: isSelected ? null : context.colors.onSurface,
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
}
