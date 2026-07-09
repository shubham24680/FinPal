import 'dart:developer';
import 'package:finpal/app/app.dart';

class PersonalDetailsScreen extends ConsumerWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);

    if (onboardingState.buttonState == ButtonState.loading) {
      return SplashScreen();
    }

    return ResponsiveBuilder(
      builder: (context, screenType) {
        final isMobile = screenType.isMobile;
        final items = [
          _buildTopItem(context, ref),
          _buildMainItem(context, ref, isMobile: isMobile),
        ];

        final screen = isMobile
            ? Stack(children: items)
            : Row(children: items.map((e) => Expanded(child: e)).toList());

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: screen,
        );
      },
    );
  }

  Widget _buildTopItem(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.topCenter,
      fit: StackFit.passthrough,
      children: [
        CustomImage(
          imageUrl: AppImages.personalDetailsScreen,
          fit: BoxFit.fitWidth,
        ),
        Align(
          alignment: Alignment.topRight,
          child: CustomChip(
            label: "Skip",
            onTap: () async {
              await ref.read(onboardingProvider.notifier).setupDefaultData();
            },
          ),
        ).padding(top: context.viewPadding.top, right: 16.r),
      ],
    );
  }

  Widget _buildMainItem(BuildContext context, WidgetRef ref, {bool isMobile = true}) {
    final height = context.screenHeight;
    final bottomPadding = context.viewInsets.bottom;
    final onboardingState = ref.watch(onboardingProvider);
    final personalDetailsState = ref.watch(profileProvider);
    final title = [
      TypographyModel(text: "Tell us a little about"),
      TypographyModel(
        text: "\n yourself.",
        color: AppColors.primary500,
      ),
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
            text:
                "This will help us personalize your experience.\n All data stays on your device.",
            fontType: FontType.label1Regular,
            align: TextAlign.center,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          SizedBox(height: 16.spMin),
          PersonalDetailsForm(),
          SizedBox(height: 32.spMin),
          buildPageIndicator(context, onboardingState),
          SizedBox(height: 24.spMin),
          CustomButton(
            buttonState: personalDetailsState.buttonState,
            label: "Add Details",
            onTap: () async {
              final hasSubmitted = await ref.read(profileProvider.notifier).onSubmit();
              if (hasSubmitted) {
                await ref.read(onboardingProvider.notifier).setupDefaultData();
              }
              log("hasSubmitted: $hasSubmitted");
            },
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
        shadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius:
            isMobile
                ? BorderRadius.vertical(top: Radius.circular(24.r))
                : BorderRadius.zero,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: child,
        ),
      ),
    );
  }
}
