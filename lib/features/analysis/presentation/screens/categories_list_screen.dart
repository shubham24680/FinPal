import 'package:finpal/app/app.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesListScreen extends ConsumerWidget {
  const CategoriesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(categoriesMonthProvider);
    final payments = ref.watch(transactionProvider).value?.payments ?? [];
    final allCategories = ref.watch(optionNotifer).value?.categories ?? [];
    final categories = AnalysisCalculator.getCategories(
      payments,
      allCategories,
      limit: null,
      month: month,
    );

    return Scaffold(
      appBar: customAppBar(
        context,
        title: 'Categories',
        actions: [
          AppBarModel(
            icon: AppSvgs.filter,
            onTap: () async {
              final picked = await CustomBottomSheet.chooseDate(
                context,
                date: month,
                onlyMonths: true,
              );
              if (picked == null || !context.mounted) return;
              ref.read(categoriesMonthProvider.notifier).state = picked;
            },
          ),
        ],
      ),
      body:
          categories.isEmpty
              ? _buildEmpty(context)
              : ListView.separated(
                padding: EdgeInsets.all(AppConstants.sidePadding),
                itemCount: categories.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.spMin),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final showBadge = index == 0 && category.amount > 0;
                  return CategoryListTile(
                    category: category,
                    showMostPopular: showBadge,
                    onTap: () => openCategoryDetail(ref, context, category.id),
                  );
                },
              ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8.spMin,
        children: [
          CustomTypography(
            text: 'No spending this month',
            fontType: FontType.h4Semibold,
          ),
          CustomTypography(
            text: 'Try another month or add expense transactions.',
            fontType: FontType.label1Medium,
            color: context.colors.onSurface,
            align: TextAlign.center,
          ),
        ],
      ).padding(horizontal: AppConstants.sidePadding),
    );
  }
}

class CategoryListTile extends ConsumerWidget {
  const CategoryListTile({
    super.key,
    required this.category,
    required this.showMostPopular,
    required this.onTap,
  });

  final AnalysisModel category;
  final bool showMostPopular;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = category.color;
    final icon = category.icon ?? AppSvgs.bin;
    final amount = ref.formatCurrency(category.amount);

    final child = Row(
      spacing: 12.spMin,
      children: [
        CustomContainer(
          height: 40.spMin,
          width: 40.spMin,
          padding: EdgeInsets.all(8.spMin),
          backgroundColor: context.isDarkMode ? color.dimDark : color.light,
          child:
              icon.isEmpty
                  ? null
                  : CustomImage(
                    imageType: ImageType.svgLocal,
                    imageUrl: icon,
                    color: color.normal,
                  ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.spMin,
            children: [
              Row(
                children: [
                  Flexible(
                    child: CustomTypography(
                      text: category.title,
                      fontType: FontType.label1Medium,
                    ),
                  ),
                ],
              ),
              CustomTypography(
                text: '${category.count} items',
                fontType: FontType.label2Regular,
                color: context.colors.onSurface,
              ),
            ],
          ),
        ),
        CustomTypography(text: amount, fontType: FontType.label1SemiBold),
      ],
    );

    return CustomContainer(
      showShadow: true,
      backgroundColor: context.colors.surface,
      onTap: onTap,
      padding: showMostPopular ? EdgeInsets.zero : null,
      child:
          showMostPopular
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomContainer(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.spMin),
                      bottomRight: Radius.circular(16.spMin),
                    ),
                    gradient: LinearGradient(
                      colors: [AppColors.primary300, AppColors.primary700],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.spMin),
                              bottomRight: Radius.circular(16.spMin),
                            ),
                            child: Shimmer.fromColors(
                              baseColor: Colors.white.withAlpha(0),
                              highlightColor: Colors.white.withAlpha(100),
                              child: const ColoredBox(color: Colors.white),
                            ),
                          ),
                        ),
                        CustomTypography(
                          text: 'Most Popular',
                          fontType: FontType.label2SemiBold,
                          color: Colors.white,
                        ).padding(horizontal: 12.spMin, vertical: 4.spMin),
                      ],
                    ),
                  ),
                  child.padding(all: AppConstants.sidePadding),
                ],
              )
              : child,
    );
  }
}
