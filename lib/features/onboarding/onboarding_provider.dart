import 'package:finpal/app/app.dart';

class OnboardingState {
  final PageController pageController;
  final int currentIndex;

  OnboardingState({required this.pageController, required this.currentIndex});

  factory OnboardingState.initial() =>
      OnboardingState(pageController: PageController(), currentIndex: 0);

  OnboardingState copyWith({
    PageController? pageController,
    int? currentIndex,
  }) => OnboardingState(
    pageController: pageController ?? this.pageController,
    currentIndex: currentIndex ?? this.currentIndex,
  );
}

class OnboardingNotifer extends StateNotifier<OnboardingState> {
  final Ref _ref;
  OnboardingNotifer(this._ref) : super(OnboardingState.initial());

  void moveTo(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void next() {
    state.pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previous() {
    state.pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> setupDefaultData() async {
    await _ref.read(profileNotifier.notifier).save(isFistTimeVisit: false);
    await _ref.read(optionProvider.future);
    await _ref
        .read(optionProvider.notifier)
        .saveAllOptions(OnboardingConstants.allOptions);
  }
}

final onboardingProvider =
    StateNotifierProvider.autoDispose<OnboardingNotifer, OnboardingState>(
      (ref) => OnboardingNotifer(ref),
    );
