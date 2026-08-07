import 'package:finpal/app/app.dart';

class AnimatedFab extends ConsumerWidget {
  const AnimatedFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDarkMode;
    final borderGradient = SweepGradient(
      colors: [
        isDark ? AppColors.warning700 : AppColors.warning500,
        isDark ? AppColors.error700 : AppColors.error500,
        isDark ? AppColors.purple700 : AppColors.purple500,
        isDark ? AppColors.warning700 : AppColors.warning500,
      ],
    );

    return CustomContainer(
      onTap: () {
        ref.read(selectedTransactionProvider.notifier).state = null;
        context.push(AppRoutesPath.editTransaction.path);
      },
      height: 65.spMin,
      width: 65.spMin,
      borderRadius: BorderRadius.circular(1000.r),
      gradient: borderGradient,
      padding: EdgeInsets.all(2.r),
      showShadow: true,
      shadow: [
        BoxShadow(
          color: context.colors.shadow.withAlpha(35),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
      ],
      child: CustomContainer(
        borderRadius: BorderRadius.circular(1000.r),
        border: Border.all(color: context.colors.surface, width: 3.r),
        gradient: RadialGradient(
          colors: [context.colors.surface, context.colors.outlineVariant],
          stops: [0.4, 1.0],
        ),
        child: CustomImage(
          imageUrl: AppSvgs.add2,
          imageType: ImageType.svgLocal,
          height: 24.spMin,
          width: 24.spMin,
          color: context.colors.inverseSurface,
        ),
      ),
    );
  }
}
