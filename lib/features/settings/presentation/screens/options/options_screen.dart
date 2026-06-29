import 'package:finpal/app/app.dart';

class OptionsScreen extends ConsumerWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionState = ref.watch(optionNotifer);

    return Scaffold(
      appBar: customAppBar(
        context,
        title: "Manage Options",
        actions: [
          AppBarModel(
            icon: AppSvgs.add1,
            color: AppColors.primary500,
            onTap: () => context.push(AppRoutesPath.editOption.path),
          ),
        ],
      ),
      body: optionState.when(
        data: (data) => _buildOptions(context, data),
        error:
            (_, __) => Center(
              child: CustomTypography(
                text: "No options found",
                fontType: FontType.body1Medium,
                color: context.colors.onSurface,
              ),
            ),
        loading:
            () => const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }

  Widget _buildOptions(BuildContext context, OptionServices options) {
    final incomeCategories = options.byType(
      OptionsConstant.incomeCategory,
      excludeId: OptionsConstant.incomeCategory,
    );
    final expenseCategories = options.byType(
      OptionsConstant.expenseCategory,
      excludeId: OptionsConstant.expenseCategory,
    );
    final paymentMethods = options.byType(
      OptionsConstant.paymentMethod,
      excludeId: OptionsConstant.paymentMethod,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppConstants.sidePadding),
      child: Column(
        spacing: 16.spMin,
        children: [
          OptionTiles(incomeCategories, title: "Income Categories"),
          OptionTiles(expenseCategories, title: "Expense Categories"),
          OptionTiles(paymentMethods, title: "Payment Methods"),
          SizedBox(height: 50.spMin),
        ],
      ),
    );
  }
}
