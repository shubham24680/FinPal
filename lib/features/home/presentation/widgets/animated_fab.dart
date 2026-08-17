import 'dart:math' as math;

import 'package:finpal/app/app.dart';

class AnimatedFab extends ConsumerStatefulWidget {
  const AnimatedFab({super.key});

  @override
  ConsumerState<AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends ConsumerState<AnimatedFab>
    with TickerProviderStateMixin {
  late final AnimationController _rotateController;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final size = 65.spMin;

    final gradientColors = [
      isDark ? AppColors.warning700 : AppColors.warning500,
      isDark ? AppColors.purple700 : AppColors.purple500,
      isDark ? AppColors.info700 : AppColors.info500,
      isDark ? AppColors.warning700 : AppColors.warning500,
    ];

    return AnimatedBuilder(
      animation: Listenable.merge([_rotateController, _pulseAnimation]),
      builder: (context, child) {
        final angle = _rotateController.value * 2 * math.pi;

        return CustomContainer(
          onTap: () {
            ref.read(selectedTransactionProvider.notifier).state = null;
            context.push(AppRoutesPath.editTransaction.path);
          },
          height: size,
          width: size,
          borderRadius: BorderRadius.circular(1000.r),
          gradient: SweepGradient(
            transform: GradientRotation(angle),
            colors: gradientColors,
          ),
          padding: EdgeInsets.all(2.r),
          showShadow: true,
          shadow: [
            BoxShadow(
              color: context.colors.shadow.withAlpha(35),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
          child: child,
        );
      },
      child: CustomContainer(
        borderRadius: BorderRadius.circular(1000.r),
        border: Border.all(color: context.colors.surface, width: 3.r),
        gradient: RadialGradient(
          colors: [context.colors.surface, context.colors.outlineVariant],
          stops: const [0.4, 1.0],
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
