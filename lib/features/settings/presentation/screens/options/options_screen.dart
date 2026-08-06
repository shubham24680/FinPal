import 'package:finpal/app/app.dart';

class OptionsScreen extends ConsumerWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionState = ref.watch(optionNotifer);

    return Scaffold(
      appBar: customAppBar(
        context,
        title: "Manage Categories",
        actions: [
          AppBarModel(
            icon: AppSvgs.add1,
            color: AppColors.primary500,
            onTap: () {
              ref.read(selectedOptionProvider.notifier).state = null;
              context.push(AppRoutesPath.editOption.path);
            },
          ),
        ],
      ),
      body: optionState.when(
        data: (data) => _buildOptions(context, data, ref),
        error: (_, __) => _buildNoCategories(context, ref),
        loading:
            () => const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }

  Widget _buildOptions(
    BuildContext context,
    OptionServices options,
    WidgetRef ref,
  ) {
    final incomeCategories = options.byType(OptionType.income.id);
    final expenseCategories = options.byType(OptionType.expense.id);
    final paymentMethods = options.byType(OptionType.paymentMethod.id);
    final isAllEmpty =
        incomeCategories.isEmpty &&
        expenseCategories.isEmpty &&
        paymentMethods.isEmpty;

    if (isAllEmpty) return _buildNoCategories(context, ref);

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppConstants.sidePadding),
      child: Column(
        spacing: 16.spMin,
        children: [
          if (incomeCategories.isNotEmpty)
            OptionTiles(incomeCategories, title: "Income Categories"),
          if (expenseCategories.isNotEmpty)
            OptionTiles(expenseCategories, title: "Expense Categories"),
          if (paymentMethods.isNotEmpty)
            OptionTiles(paymentMethods, title: "Payment Methods"),
          SizedBox(height: AppConstants.appNavPadding),
        ],
      ),
    );
  }

  Widget _buildNoCategories(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomImage(
          imageUrl: AppImages.noCategories,
        ).padding(horizontal: 60.spMin),
        CustomTypography(
          text: "No Categories yet",
          fontType: FontType.h4Semibold,
        ),
        SizedBox(height: 8.spMin),
        CustomTypography(
          text:
              "Looks like you haven't added any categories yet. Add a category to get started.",
          fontType: FontType.label1Medium,
          color: context.colors.onSurface,
          align: TextAlign.center,
        ),
        SizedBox(height: 16.spMin),
        CustomButton(
          label: "Add your first category",
          prefixIcon: AppSvgs.add1,
          onTap: () {
            ref.read(selectedOptionProvider.notifier).state = null;
            context.push(AppRoutesPath.editOption.path);
          },
        ),
      ],
    ).padding(horizontal: AppConstants.sidePadding);
  }
}
