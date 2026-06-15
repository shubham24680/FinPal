import 'package:finpal/app/app.dart';

class IntroScreen extends ConsumerWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveBuilder(
      builder: (context, screenType) {
        final isMobile = screenType.isMobile;
        final items = [
          _buildTopItem(),
          _buildMainItem(ref, context, isMobile: isMobile),
        ];

        return isMobile
            ? Stack(children: items)
            : Row(children: items.map((e) => Expanded(child: e)).toList());
      },
    );
  }

  Widget _buildTopItem() {
    return CustomImage(imageUrl: AppImages.introScreen, fit: BoxFit.fitWidth);
  }

  Widget _buildMainItem(
    WidgetRef ref,
    BuildContext context, {
    bool isMobile = true,
  }) {
    final height = context.screenHeight;
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    final title = [
      OnboardingTypographyModel(text: "Track "),
      OnboardingTypographyModel(text: "Expenses.", color: AppColors.primary500),
      OnboardingTypographyModel(text: "\nBuild Better "),
      OnboardingTypographyModel(text: "Habits.", color: AppColors.primary500),
    ];

    final child = SafeArea(
      top: !isMobile,
      left: isMobile,
      child: Column(
        mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
        children: [
          SizedBox(height: 20.spMin),
          onboardingTypo(context, title),
          CustomTypography(
            text: "Monitor your spending and make smarter financial decisions.",
            fontType: FontType.label1Regular,
            align: TextAlign.center,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          isMobile ? SizedBox(height: 32.spMin) : const Spacer(),
          buildPageIndicator(context, onboardingState),
          SizedBox(height: 24.spMin),
          CustomButton(
            buttonState: onboardingState.buttonState,
            label: "Get Started",
            suffixIcon: AppSvgs.arrowRight,
            onTap: () => onboardingNotifier.next(),
          ),
          SizedBox(height: 40.spMin),
        ],
      ),
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomContainer(
        height: isMobile ? null : height,
        backgroundColor: Theme.of(context).colorScheme.surface,
        padding: EdgeInsets.symmetric(horizontal: 16.r),
        borderRadius:
            isMobile
                ? BorderRadius.vertical(top: Radius.circular(24.r))
                : BorderRadius.zero,
        child: child,
      ),
    );
  }
}
