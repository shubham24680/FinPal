import 'package:finpal/app/app.dart';

class IntroScreen extends ConsumerWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveBuilder(
      builder: (context, screenType) {
        final isMobile = screenType.isMobile;
        final items = [
          _buildTopItem(context),
          _buildMainItem(ref, context, isMobile: isMobile),
        ];

        return isMobile
            ? Stack(children: items)
            : Row(children: items.map((e) => Expanded(child: e)).toList());
      },
    );
  }

  Widget _buildTopItem(BuildContext context) {
    return Stack(
      children: [
        CustomImage(imageUrl: AppImages.introScreen, fit: BoxFit.fitWidth),
        Align(
          alignment: Alignment.topLeft,
          child: CustomImage(imageUrl: AppImages.splash, height: 40.spMin),
        ).padding(top: context.viewPadding.top, left: 16.r),
      ],
    );
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
      TypographyModel(text: "Track "),
      TypographyModel(text: "Expenses.", color: AppColors.primary500),
      TypographyModel(text: "\nBuild Better "),
      TypographyModel(text: "Habits.", color: AppColors.primary500),
    ];

    final child = SafeArea(
      top: !isMobile,
      left: isMobile,
      child: Column(
        mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
        children: [
          SizedBox(height: 20.spMin),
          CustomTypography(typos: title),
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
