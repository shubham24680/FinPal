import 'package:finpal/app/app.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: PageView.builder(
                controller: onboardingState.pageController,
                itemCount: OnboardingConstants.onboardingData.length,
                onPageChanged: (index) => onboardingNotifier.moveTo(index),
                itemBuilder: (context, index) {
                  final data = OnboardingConstants.onboardingData[index];
                  return _buildOnboardingItem(data);
                },
              ),
            ),
            _buildFooter(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingItem(OnboardingModel data) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: OnboardingConstants.onboardingPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 300.w,
                  height: 300.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: PrimaryColors.shade50,
                  ),
                ),
                CustomImage(imageUrl: data.image),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              style: CustomTypography(fontType: FontType.h1Bold).getTextStyle(),
              children: List.generate(
                data.title.length,
                (index) => TextSpan(
                  text: data.title[index],
                  style:
                      (index % 2 == 1)
                          ? CustomTypography(
                            fontType: FontType.h1Semibold,
                          ).getTextStyle()
                          : null,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.w),
          CustomTypography(text: data.subtitle, height: 1.5),
          SizedBox(height: 20.w),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);

    final padding = OnboardingConstants.onboardingPadding;
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
                onTap: () => onboardingNotifier.previousPage(),
                borderRadius: BorderRadius.circular(22.r),
                child: CustomImage(
                  imageType: ImageType.svgLocal,
                  imageUrl: AppSvgs.arrowLeft,
                  width: 24.w,
                ),
              ),
          SmoothPageIndicator(
            controller: state.pageController,
            count: OnboardingConstants.onboardingData.length,
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
            onTap: () {
              if (state.currentIndex <
                  OnboardingConstants.onboardingData.length - 1) {
                onboardingNotifier.next();
              } else {
                context.go("/");
                ref.read(profileNotifier.notifier).save(isFistTimeVisit: false);
              }
            },
            borderRadius: BorderRadius.circular(22.r),
            child: CustomImage(
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
