import 'dart:developer';

import 'package:finpal/app/app.dart';

class OnboardingState {
  final PageController pageController;
  final int currentIndex;
  final ButtonState buttonState;
  final TextEditingController nameController;
  final TextEditingController dateOfBirthController;
  final String name;
  final String dob;
  final String gender;

  OnboardingState({
    required this.pageController,
    required this.currentIndex,
    required this.buttonState,
    required this.nameController,
    required this.dateOfBirthController,
    required this.name,
    required this.dob,
    required this.gender,
  });

  factory OnboardingState.initial() => OnboardingState(
    pageController: PageController(),
    currentIndex: 0,
    buttonState: ButtonState.enabled,
    nameController: TextEditingController(),
    dateOfBirthController: TextEditingController(),
    name: "",
    dob: "",
    gender: "",
  );

  OnboardingState copyWith({
    PageController? pageController,
    int? currentIndex,
    ButtonState? buttonState,
    String? name,
    String? dob,
    String? gender,
  }) => OnboardingState(
    pageController: pageController ?? this.pageController,
    currentIndex: currentIndex ?? this.currentIndex,
    buttonState: buttonState ?? this.buttonState,
    name: name ?? this.name,
    dob: dob ?? this.dob,
    nameController: nameController,
    dateOfBirthController: dateOfBirthController,
    gender: gender ?? this.gender,
  );
}

class OnboardingNotifer extends StateNotifier<OnboardingState> {
  final Ref _ref;
  OnboardingNotifer(this._ref) : super(OnboardingState.initial());

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
    onChange();
  }

  void setName(String name) {
    state = state.copyWith(name: name);
    onChange();
  }

  void setDob(String dob) {
    state = state.copyWith(dob: dob);
    onChange();
  }

  void onChange() {
    final isValid =
        state.name.isNotEmpty ||
        state.dob.isNotEmpty ||
        state.gender.isNotEmpty;
    log(
      "isValid: $isValid, name: ${state.name}, dob: ${state.dob}, gender: ${state.gender}",
    );
    state = state.copyWith(
      buttonState: isValid ? ButtonState.enabled : ButtonState.disabled,
    );
  }

  void next() {
    state = state.copyWith(buttonState: ButtonState.disabled);
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
    state = state.copyWith(buttonState: ButtonState.loading);
    await _ref.read(profileNotifier.notifier).save(isFirstTimeVisit: false);
    await _ref.read(optionNotifer.future);
    await _ref
        .read(optionNotifer.notifier)
        .saveAllOptions(OnboardingConstants.allOptions);
    state = state.copyWith(buttonState: ButtonState.enabled);
  }
}

final onboardingProvider =
    StateNotifierProvider.autoDispose<OnboardingNotifer, OnboardingState>(
      (ref) => OnboardingNotifer(ref),
    );
