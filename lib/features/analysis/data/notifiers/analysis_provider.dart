import 'package:finpal/app/app.dart';

final analysisPeriodProvider = StateProvider<AnalysisPeriod>(
  (ref) => AnalysisPeriod.thisMonth,
);
final hideBalanceProvider = StateProvider<bool>((ref) => false);

final selectedCategoryIdProvider = StateProvider<String?>((ref) => null);

final categoriesMonthProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

void openCategoriesList(WidgetRef ref, BuildContext context) {
  ref.read(categoriesMonthProvider.notifier).state = DateTime.now();
  context.push(AppRoutesPath.categories.path);
}

void openCategoryDetail(
  WidgetRef ref,
  BuildContext context,
  String categoryId,
) {
  ref.read(selectedCategoryIdProvider.notifier).state = categoryId;
  context.push(AppRoutesPath.categoryDetail.path);
}
