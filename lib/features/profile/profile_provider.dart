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
    int? profileImageIndex,
    String? gender,
    String? name,
    String? dateOfBirth,
    bool? isFistTimeVisit,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final profile = state.value ?? ProfileModel();
      final profileModel = profile.copyWith(
        profileImageIndex: profileImageIndex,
        gender: gender,
        name: name,
        dateOfBirth: dateOfBirth,
        isFistTimeVisit: isFistTimeVisit,
      );
      await _hiveService.saveData(_key, profileModel);
      return profileModel;
    });
  }
}

final profileNotifier = AsyncNotifierProvider<ProfileNotifier, ProfileModel>(
  () => ProfileNotifier(),
);

class ProfileState {
  final int profilePicIndex;
  final OptionModel? gender;
  final bool tryEditing;
  final String? name, dateOfBirth;
  final TextEditingController nameController, dateOfBirthController;

  ProfileState({
    required this.profilePicIndex,
    required this.tryEditing,
    this.name,
    this.gender,
    this.dateOfBirth,
    required this.nameController,
    required this.dateOfBirthController,
  });

  factory ProfileState.initial() {
    return ProfileState(
      profilePicIndex: 0,
      tryEditing: false,
      nameController: TextEditingController(),
      dateOfBirthController: TextEditingController(),
    );
  }

  ProfileState copyWith({
    int? profilePicIndex,
    bool? tryEditing,
    String? name,
    OptionModel? gender,
    String? dateOfBirth,
  }) {
    return ProfileState(
      profilePicIndex: profilePicIndex ?? this.profilePicIndex,
      tryEditing: tryEditing ?? this.tryEditing,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nameController: nameController,
      dateOfBirthController: dateOfBirthController,
    );
  }
}

class ProfileProvider extends StateNotifier<ProfileState> {
  final Ref ref;
  ProfileProvider(this.ref) : super(ProfileState.initial()) {
    loadData();
  }

  Future<void> loadData() async {
    final profile = ref.watch(profileNotifier);
    state = state.copyWith(
      profilePicIndex: profile.value?.profileImageIndex,
      name: profile.value?.name,
      gender: getGender(profile.value?.gender),
      dateOfBirth: profile.value?.dateOfBirth,
    );
  }

  OptionModel? getGender(String? gender) {
    if (gender == null) return null;
    return ProfileConstants.gender.firstWhere(
      (e) => e.name.toLowerCase() == gender.toLowerCase(),
    );
  }

  Future<void> saveData() async {
    state = state.copyWith(
      name: state.nameController.text,
      dateOfBirth: state.dateOfBirthController.text,
    );

    await ref
        .read(profileNotifier.notifier)
        .save(
          profileImageIndex: state.profilePicIndex,
          gender: state.gender?.name,
          name: state.name,
          dateOfBirth: state.dateOfBirth,
        );

    log("Saved succesfully at index ${state.profilePicIndex}");
  }

  void toggle() {
    state = state.copyWith(tryEditing: !state.tryEditing);
    log("set editing to ${state.tryEditing}");
  }

  void setProfileIndexTo(int index) {
    state = state.copyWith(profilePicIndex: index);
    log("set index to ${state.profilePicIndex}");
  }

  void setGender(OptionModel gender) {
    state = state.copyWith(gender: gender);
    log("set index to ${state.gender}");
  }

  void loadField() {
    state.nameController.text = state.name ?? "";
    state.dateOfBirthController.text = state.dateOfBirth ?? "";
  }
}

final profileProvider =
    StateNotifierProvider.autoDispose<ProfileProvider, ProfileState>(
      (ref) => ProfileProvider(ref),
    );
