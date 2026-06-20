import 'package:finpal/app/app.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView.builder(
        controller: onboardingState.pageController,
        itemCount: OnboardingContent.values.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) => OnboardingContent.values[index].screen,
      ),
    );
  }
}
