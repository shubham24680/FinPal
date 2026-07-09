import 'package:finpal/app/app.dart';

class CurrencyScreen extends ConsumerWidget {
  const CurrencyScreen({super.key});

  final List<CurrencyContants> _currencies = CurrencyContants.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCurrency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: customAppBar(context, title: "Currency"),
      body: CustomContainer(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.all(AppConstants.sidePadding),
        child: ListView.separated(
          itemCount: _currencies.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            final currency = _currencies[index];
            final name = "${currency.currency} (${currency.symbol})";
            final isSelected = selectedCurrency == currency;
            final borderColor =
                isSelected
                    ? context.colors.primary
                    : context.colors.onSurfaceVariant;
            final borderWidth = isSelected ? 3.spMin : 1.spMin;
            final backgroundColor =
                isSelected
                    ? context.colors.surface
                    : context.colors.onSurfaceVariant.withAlpha(50);

            return CustomContainer(
              onTap:
                  () => ref
                      .read(settingsNotifier.notifier)
                      .save(currency: currency),
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTypography(text: name, fontType: FontType.body2Medium),
                  CustomContainer(
                    height: 20.spMin,
                    width: 20.spMin,
                    backgroundColor: backgroundColor,
                    border: Border.all(color: borderColor, width: borderWidth),
                    borderRadius: BorderRadius.circular(1000.r),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}