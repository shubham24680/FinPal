import 'package:finpal/app/app.dart';

class AnalysisPeriodChips extends ConsumerWidget {
  const AnalysisPeriodChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(analysisPeriodProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.sidePadding,
        // vertical: 16.spMin,
      ),
      child: Row(
        spacing: 8.spMin,
        children:
            AnalysisPeriod.values
                .map(
                  (period) => CustomChip(
                    label: period.label,
                    selected: selected == period,
                    outlined: true,
                    variant:
                        selected == period
                            ? ChipVariant.primary
                            : ChipVariant.inactive,
                    onTap:
                        () =>
                            ref.read(analysisPeriodProvider.notifier).state =
                                period,
                  ),
                )
                .toList(),
      ),
    );
  }
}
