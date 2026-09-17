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
    double? monthlyIncome,
    bool clearMonthlyIncome = false,
  }) async {
    final profile = state.value ?? ProfileModel();
    final previousImage = profile.profileImage;
    state = await AsyncValue.guard(() async {
      final profileModel = profile.copyWith(
        profileImage: profileImage,
        name: name,
        dob: dob,
        gender: gender,
        monthlyIncome: monthlyIncome,
        clearMonthlyIncome: clearMonthlyIncome,
      );

      await _hiveService.saveData(_key, profileModel);
      return profileModel;
    });

    // Only once the new path is safely stored, so a failed save keeps the old
    // avatar on disk.
    final savedImage = state.value?.profileImage;
    if (savedImage != null && savedImage != previousImage) {
      await ImageStorage.discard(previousImage);
    }
  }

  Future<void> clearData() async {
    final previousImage = state.value?.profileImage;
    state = await AsyncValue.guard(() async {
      await _hiveService.clearData(_key);
      return ProfileModel();
    });
    await ImageStorage.discard(previousImage);
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
  final double? monthlyIncome;
  final ButtonState buttonState;

  ProfileState({
    required this.profileImage,
    required this.name,
    required this.dob,
    required this.gender,
    this.monthlyIncome,
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
    double? monthlyIncome,
    bool clearMonthlyIncome = false,
    ButtonState? buttonState,
  }) {
    return ProfileState(
      profileImage: profileImage ?? this.profileImage,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      monthlyIncome:
          clearMonthlyIncome ? null : monthlyIncome ?? this.monthlyIncome,
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
      monthlyIncome: profile?.monthlyIncome,
    );
  }

  void setProfileImage(String? profileImage) {
    if (profileImage == null) return;
    state = state.copyWith(profileImage: profileImage);
    onChange();
  }

  void setName(String name) {
    state = state.copyWith(name: name.trim());
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

  void setMonthlyIncome(String? monthlyIncome) {
    final amount = _parseMonthlyIncome(monthlyIncome);
    state =
        amount == null
            ? state.copyWith(clearMonthlyIncome: true)
            : state.copyWith(monthlyIncome: amount);
    onChange();
  }

  double? _parseMonthlyIncome(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final amount = ref.parseCurrency(raw);
      return amount > 0 ? amount : null;
    } on FormatException {
      return null;
    }
  }

  void onChange() {
    final isValid =
        state.name.isNotEmpty ||
        state.dob.isNotEmpty ||
        state.gender.isNotEmpty ||
        state.profileImage.isNotEmpty ||
        state.monthlyIncome != null;

    state = state.copyWith(
      buttonState: isValid ? ButtonState.enabled : ButtonState.disabled,
    );
  }

  Future<bool> onSubmit({bool skipValidation = false, bool setDefaultData = false}) async {
    state = state.copyWith(buttonState: ButtonState.loading);
    try {
      if (!skipValidation) {
        await ref
            .read(profileNotifier.notifier)
            .save(
              profileImage: state.profileImage,
              name: state.name.trim(),
              dob: state.dob,
              gender: state.gender,
              monthlyIncome: state.monthlyIncome,
              clearMonthlyIncome: state.monthlyIncome == null,
            );
      }

      if (setDefaultData) {
        await ref.read(onboardingProvider.notifier).setupDefaultData();
      }
      return true;
    } catch (_) {
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
