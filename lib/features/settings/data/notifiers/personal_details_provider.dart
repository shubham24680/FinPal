import 'package:finpal/app/app.dart';

class PersonalDetailsState {
  final String name;
  final String dob;
  final String gender;
  final ButtonState buttonState;

  PersonalDetailsState({
    required this.name,
    required this.dob,
    required this.gender,
    required this.buttonState,
  });

  factory PersonalDetailsState.initial() => PersonalDetailsState(
    name: "",
    dob: "",
    gender: "",
    buttonState: ButtonState.disabled,
  );

  PersonalDetailsState copyWith({
    String? name,
    String? dob,
    String? gender,
    ButtonState? buttonState,
  }) => PersonalDetailsState(
    name: name ?? this.name,
    dob: dob ?? this.dob,
    gender: gender ?? this.gender,
    buttonState: buttonState ?? this.buttonState,
  );
}

class PersonalDetailsNotifer extends StateNotifier<PersonalDetailsState> {
  PersonalDetailsNotifer() : super(PersonalDetailsState.initial());

  void setName(String name) {
    state = state.copyWith(name: name);
    onChange();
  }

  void setDob(String dob) {
    state = state.copyWith(dob: dob);
    onChange();
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
    onChange();
  }

  void onChange() {
    final isValid = state.name.isNotEmpty || state.dob.isNotEmpty || state.gender.isNotEmpty;
    state = state.copyWith(buttonState: isValid ? ButtonState.enabled : ButtonState.disabled);
  }

  Future<bool> onSubmit() async {
    state = state.copyWith(buttonState: ButtonState.loading);
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(buttonState: ButtonState.enabled);
    return true;
  }
}

final personalDetailsProvider = StateNotifierProvider.autoDispose<PersonalDetailsNotifer, PersonalDetailsState>(
  (ref) => PersonalDetailsNotifer(),
);