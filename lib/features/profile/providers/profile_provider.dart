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
    String? name,
    bool? isFirstTimeVisit,
    bool? isFingerprintEnabled,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final profile = state.value ?? ProfileModel();
      final profileModel = profile.copyWith(
        profileImageIndex: profileImageIndex,
        name: name,
        isFirstTimeVisit: isFirstTimeVisit,
        isFingerprintEnabled: isFingerprintEnabled,
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
  final bool tryEditing;
  final String? name;
  final TextEditingController nameController;

  ProfileState({
    required this.profilePicIndex,
    required this.tryEditing,
    this.name,
    required this.nameController,
  });

  factory ProfileState.initial() {
    return ProfileState(
      profilePicIndex: 0,
      tryEditing: false,
      nameController: TextEditingController(),
    );
  }

  ProfileState copyWith({
    int? profilePicIndex,
    bool? tryEditing,
    String? name,
  }) {
    return ProfileState(
      profilePicIndex: profilePicIndex ?? this.profilePicIndex,
      tryEditing: tryEditing ?? this.tryEditing,
      name: name ?? this.name,
      nameController: nameController,
    );
  }
}

class ProfileProvider extends StateNotifier<ProfileState> {
  final Ref ref;
  ProfileProvider(this.ref) : super(ProfileState.initial()) {
    loadData();
  }

  Future<void> loadData() async {
    final profile = ref.watch(profileNotifier).value;
    state = state.copyWith(
      profilePicIndex: profile?.profileImageIndex,
      name: profile?.name,
    );
  }

  Future<void> saveData() async {
    state = state.copyWith(name: state.nameController.text);

    await ref
        .read(profileNotifier.notifier)
        .save(profileImageIndex: state.profilePicIndex, name: state.name);

    log("Saved succesfully at index ${state.profilePicIndex}");
  }

  void toggle() {
    state = state.copyWith(tryEditing: !state.tryEditing);
    if (state.tryEditing) {
      loadField();
    }
    log("set editing to ${state.tryEditing}");
  }

  void setProfileIndexTo(int index) {
    state = state.copyWith(profilePicIndex: index);
    log("set index to ${state.profilePicIndex}");
  }

  void loadField() {
    state.nameController.text = state.name ?? "";
  }
}

final profileProvider =
    StateNotifierProvider.autoDispose<ProfileProvider, ProfileState>(
      (ref) => ProfileProvider(ref),
    );
