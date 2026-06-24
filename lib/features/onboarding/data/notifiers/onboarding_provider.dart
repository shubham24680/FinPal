import 'package:finpal/app/app.dart';

class OnboardingState {
  final PageController pageController;
  final int currentIndex;
  final ButtonState buttonState;

  OnboardingState({
    required this.pageController,
    required this.currentIndex,
    required this.buttonState,
  });

  factory OnboardingState.initial() => OnboardingState(
    pageController: PageController(),
    currentIndex: 0,
    buttonState: ButtonState.enabled,
  );

  OnboardingState copyWith({
    PageController? pageController,
    int? currentIndex,
    ButtonState? buttonState,
  }) => OnboardingState(
    pageController: pageController ?? this.pageController,
    currentIndex: currentIndex ?? this.currentIndex,
    buttonState: buttonState ?? this.buttonState,
  );
}

class OnboardingNotifer extends StateNotifier<OnboardingState> {
  final Ref _ref;
  OnboardingNotifer(this._ref) : super(OnboardingState.initial());

  void next() {
    state = state.copyWith(buttonState: ButtonState.disabled);
    state.pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> setupDefaultData() async {
    state = state.copyWith(buttonState: ButtonState.loading);
    await _ref.read(optionNotifer.future);
    await _ref
        .read(optionNotifer.notifier)
        .saveAllOptions(OnboardingConstants.allOptions);
    await Future.delayed(const Duration(seconds: 3));
    await _ref.read(settingsNotifier.notifier).save(isFirstVisit: false);
    state = state.copyWith(buttonState: ButtonState.enabled);
  }
}

final onboardingProvider =
    StateNotifierProvider.autoDispose<OnboardingNotifer, OnboardingState>(
      (ref) => OnboardingNotifer(ref),
    );
