import 'dart:developer';

import 'package:finpal/app/app.dart';

final profileBoxProvider = Provider<Box<ProfileModel>>(
  (ref) => throw UnimplementedError(),
);

class ProfileNotifier extends AsyncNotifier<ProfileModel> {
  late HiveService<ProfileModel> _hiveService;
  static const _key = 'user';

  @override
  Future<ProfileModel> build() async {
    final box = ref.watch(profileBoxProvider);
    _hiveService = HiveService(box);
    return _hiveService.getData(_key) ?? ProfileModel();
  }

  Future<void> save({
    String? profileImage,
    String? name,
    String? dob,
    String? gender,
  }) async {
    state = const AsyncLoading();
    final profile = state.value ?? ProfileModel();
    state = await AsyncValue.guard(() async {
      final profileModel = profile.copyWith(
        profileImage: profileImage,
        name: name,
        dob: dob,
        gender: gender,
      );

      await _hiveService.saveData(_key, profileModel);
      return profileModel;
    });
  }

  bool isFieldsNotEmpty() {
    final profile = state.value;
    return (profile?.name.isNotEmpty ?? false) ||
        (profile?.dob.isNotEmpty ?? false) ||
        (profile?.gender.isNotEmpty ?? false) ||
        (profile?.profileImage.isNotEmpty ?? false);
  }
}

final profileNotifier = AsyncNotifierProvider<ProfileNotifier, ProfileModel>(
  () => ProfileNotifier(),
);

class ProfileState {
  final String profileImage;
  final String name;
  final String dob;
  final String gender;
  final ButtonState buttonState;

  ProfileState({
    required this.profileImage,
    required this.name,
    required this.dob,
    required this.gender,
    required this.buttonState,
  });

  factory ProfileState.initial() {
    return ProfileState(
      profileImage: "",
      name: "",
      dob: "",
      gender: "",
      buttonState: ButtonState.disabled,
    );
  }

  ProfileState copyWith({
    String? profileImage,
    String? name,
    String? dob,
    String? gender,
    ButtonState? buttonState,
  }) {
    return ProfileState(
      profileImage: profileImage ?? this.profileImage,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      buttonState: buttonState ?? this.buttonState,
    );
  }
}

class ProfileProvider extends StateNotifier<ProfileState> {
  final Ref ref;
  ProfileProvider(this.ref) : super(ProfileState.initial()) {
    loadData();
  }

  Future<void> loadData() async {
    final profile = ref.read(profileNotifier).value;
    state = state.copyWith(
      profileImage: profile?.profileImage,
      name: profile?.name,
      dob: profile?.dob,
      gender: profile?.gender,
    );
  }

  void setProfileImage(String? profileImage) {
    if (profileImage == null) return;
    state = state.copyWith(profileImage: profileImage);
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

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
    onChange();
  }

  void onChange() {
    final isValid =
        state.name.isNotEmpty ||
        state.dob.isNotEmpty ||
        state.gender.isNotEmpty ||
        state.profileImage.isNotEmpty;
    log(
      "isValid: $isValid ${state.name} ${state.dob} ${state.gender} ${state.profileImage}",
    );
    state = state.copyWith(
      buttonState: isValid ? ButtonState.enabled : ButtonState.disabled,
    );
  }

  Future<bool> onSubmit() async {
    state = state.copyWith(buttonState: ButtonState.loading);
    try {
      await ref
          .read(profileNotifier.notifier)
          .save(
            profileImage: state.profileImage,
            name: state.name,
            dob: state.dob,
            gender: state.gender,
          );
      return true;
    } catch (e) {
      return false;
    } finally {
      state = state.copyWith(buttonState: ButtonState.enabled);
    }
  }
}

final profileProvider =
    StateNotifierProvider.autoDispose<ProfileProvider, ProfileState>(
      (ref) => ProfileProvider(ref),
    );
