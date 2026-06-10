import 'dart:developer';

import 'package:finpal/app/app.dart';
import 'package:finpal/core/theme/app_colors.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static final _onboardingData = OnboardingContent.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView.builder(
        controller: onboardingState.pageController,
        itemCount: _onboardingData.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              final children = _buildOnboardingContentItem(
                ref,
                context,
                _onboardingData[index],
                isMobile: isMobile,
              );

              final screen =
                  isMobile
                      ? Stack(children: children)
                      : Row(
                        children:
                            children.map((e) => Expanded(child: e)).toList(),
                      );
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: screen,
              );
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildOnboardingContentItem(
    WidgetRef ref,
    BuildContext context,
    OnboardingContent type, {
    bool isMobile = true,
  }) {
    final height = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    final onboarding = type.data;
    final isOnboarding = type == OnboardingContent.onboarding;
    final button = onboarding.button;

    final child = SafeArea(
      top: !isMobile,
      left: isMobile,
      child: Column(
        mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
        children: [
          SizedBox(height: 20.spMin),
          _buildOnboardingContent(context, type),
          (!isMobile && isOnboarding)
              ? const Spacer()
              : SizedBox(height: 32.spMin),
          _buildPageIndicator(context, onboardingState),
          SizedBox(height: 24.spMin),
          CustomButton(
            label: button.label,
            prefixIcon: button.prefixIcon,
            suffixIcon: button.suffixIcon,
            onTap: () => onboardingNotifier.next(),
          ),
          SizedBox(height: 40.spMin),
        ],
      ),
    );

    return [
      CustomImage(imageUrl: onboarding.image, fit: BoxFit.fitWidth),
      Align(
        alignment: Alignment.bottomCenter,
        child: CustomContainer(
          height: isMobile ? null : height,
          backgroundColor: Theme.of(context).colorScheme.surface,
          padding: EdgeInsets.symmetric(horizontal: 16.r),
          borderRadius:
              isMobile
                  ? BorderRadius.vertical(top: Radius.circular(24.r))
                  : BorderRadius.zero,
          child:
              type == OnboardingContent.onboarding
                  ? child
                  : SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: child,
                  ),
        ),
      ),
    ];
  }

  Widget _buildOnboardingContent(BuildContext context, OnboardingContent type) {
    final onboarding = type.data;
    final subtitle = onboarding.subtitle?.text ?? "";
    final child = switch (type) {
      OnboardingContent.personalDetails => _buildPersonalDetails(),
      OnboardingContent.security => SizedBox.shrink(),
      _ => SizedBox.shrink(),
    };

    return Column(
      children: [
        onboardingTypo(context, onboarding.title),
        CustomTypography(
          text: subtitle,
          fontType: FontType.label1Regular,
          align: TextAlign.center,
        ),
        child,
      ],
    );
  }

  Widget _buildPersonalDetails() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16.spMin,
      children: [
        SizedBox(height: 16.spMin),
        CustomTextField(
          header: "FULL NAME",
          hintText: "Name",
          helperText: "This is a helper text",
        ),
        CustomTextField(
          textFieldType: TextFieldType.dropdown,
          items: ["2026", "2025", "2024", "2023", "2022", "2021", "2020"],
          onChanged: (value) => {log(value ?? "")},
          header: "DATE OF BIRTH",
          hintText: "DOB",
          helperText: "This is a helper text",
        ),
      ],
    );
  }

  Widget _buildPageIndicator(
    BuildContext context,
    OnboardingState onboardingState,
  ) {
    return SmoothPageIndicator(
      controller: onboardingState.pageController,
      count: _onboardingData.length,
      effect: ExpandingDotsEffect(
        activeDotColor: AppColors.primary500,
        dotColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        dotHeight: 8.spMin,
        dotWidth: 8.spMin,
        spacing: 6.spMin,
        expansionFactor: 2.5,
      ),
    );
  }

  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    final padding = 24.w;
    return Padding(
      padding: EdgeInsets.only(left: padding, right: padding, bottom: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (state.currentIndex == 0)
              ? SizedBox(width: 56.w)
              : CustomContainer(
                width: 56.w,
                height: 56.w,
                showShadow: true,
                onTap: () => onboardingNotifier.previous(),
                borderRadius: BorderRadius.circular(22.r),
                child: CustomImage(
                  imageType: ImageType.svgLocal,
                  imageUrl: AppSvgs.arrowLeft,
                  width: 24.w,
                ),
              ),
          SmoothPageIndicator(
            controller: state.pageController,
            count: _onboardingData.length,
            effect: ExpandingDotsEffect(
              activeDotColor: TextColors.shade900,
              dotColor: PrimaryColors.shade200,
              dotHeight: 8.w,
              dotWidth: 8.w,
              spacing: 6.w,
              expansionFactor: 2.5,
            ),
          ),
          CustomContainer(
            width: 56.w,
            height: 56.w,
            showShadow: true,
            onTap:
                state.isLoading
                    ? null
                    : () async {
                      if (state.currentIndex < _onboardingData.length - 1) {
                        onboardingNotifier.next();
                      } else {
                        await onboardingNotifier.setupDefaultData();
                        if (context.mounted) {
                          log("going to home");
                          context.go(AppRoutesPath.home.path);
                        }
                      }
                    },
            borderRadius: BorderRadius.circular(22.r),
            child:
                state.isLoading
                    ? const CircularProgressIndicator(
                      strokeCap: StrokeCap.round,
                      color: TextColors.shade900,
                    )
                    : CustomImage(
                      imageType: ImageType.svgLocal,
                      imageUrl: AppSvgs.arrowRight,
                      width: 24.w,
                    ),
          ),
        ],
      ),
    );
  }
}
