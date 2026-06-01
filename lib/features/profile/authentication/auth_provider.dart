import 'package:finpal/app/app.dart';

final pinBoxProvider = Provider<Box<String>>(
  (ref) => throw UnimplementedError(),
);
final enableFingerprintProvider = StateProvider<bool>((ref) => false);

enum ToastType { normal, error, success }

enum PinScreen {
  create(
    "Create Passcode",
    "Set your passcode",
    "Enter a 6-digit passcode to secure your account",
  ),
  verify(
    "Verify Passcode",
    "Welcome back!",
    "Please type in your passcode to continue",
  ),
  confirm(
    "Confirm Passcode",
    "Re-enter your passcode",
    "Re-enter your passcode to confirm",
  );

  const PinScreen(this.label, this.header, this.description);
  final String label, header, description;
}

class AuthState {
  final PinScreen step;
  final String confirmPin;
  final String createdPin;
  final String oldPin;
  final ToastType? toastType;
  final String? message;
  final int profilePicIndex;
  final bool isBiometricEnabled;
  final bool isUnlocked;

  AuthState({
    required this.step,
    required this.confirmPin,
    required this.oldPin,
    this.toastType,
    this.message,
    required this.createdPin,
    required this.profilePicIndex,
    required this.isBiometricEnabled,
    this.isUnlocked = false,
  });

  factory AuthState.initial() => AuthState(
    step: PinScreen.create,
    confirmPin: '',
    createdPin: '',
    oldPin: '',
    profilePicIndex: 0,
    toastType: ToastType.normal,
    isBiometricEnabled: false,
    isUnlocked: false,
  );

  AuthState copyWith({
    PinScreen? step,
    String? confirmPin,
    String? createdPin,
    String? oldPin,
    ToastType? toastType,
    String? message,
    int? profilePicIndex,
    bool? isBiometricEnabled,
    bool? isUnlocked,
  }) => AuthState(
    step: step ?? this.step,
    confirmPin: confirmPin ?? this.confirmPin,
    createdPin: createdPin ?? this.createdPin,
    oldPin: oldPin ?? this.oldPin,
    toastType: toastType ?? this.toastType,
    message: message ?? this.message,
    profilePicIndex: profilePicIndex ?? this.profilePicIndex,
    isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    isUnlocked: isUnlocked ?? this.isUnlocked,
  );
}

class AuthProvider extends StateNotifier<AuthState> {
  final Ref ref;
  final int pinLength = 6;
  AuthProvider(this.ref) : super(AuthState.initial()) {
    _loadData();
  }

  void _loadData() {
    final profile = ref.read(profileNotifier).value;
    if (profile == null) return;
    state = state.copyWith(
      profilePicIndex: profile.profileImageIndex,
      step: profile.isPasscodeEnabled ? PinScreen.verify : PinScreen.create,
      isBiometricEnabled: profile.isFingerprintEnabled,
    );
  }

  void _unlockSession() {
    if (AppRoutes.isAppLocked) {
      AppRoutes.isAppLocked = false;
      state = state.copyWith(isUnlocked: true);
      return;
    }

    state = state.copyWith(step: PinScreen.create);
    onClear();
  }

  void onChanged(String digit) {
    if (state.confirmPin.length >= pinLength) return;
    state = state.copyWith(
      confirmPin: state.confirmPin + digit,
      toastType: ToastType.normal,
    );
    if (state.confirmPin.length == pinLength) {
      _onPinComplete();
    }
  }

  void onBackspace() {
    if (state.confirmPin.isEmpty) return;
    state = state.copyWith(
      confirmPin: state.confirmPin.substring(0, state.confirmPin.length - 1),
      toastType: ToastType.normal,
    );
  }

  void onClear() {
    if (state.confirmPin.isEmpty) return;
    state = state.copyWith(confirmPin: "", toastType: ToastType.normal);
  }

  void _onPinComplete() {
    switch (state.step) {
      case PinScreen.create:
        state = state.copyWith(
          step: PinScreen.confirm,
          createdPin: state.confirmPin,
        );
        break;
      case PinScreen.confirm:
        _savePin();
        break;
      case PinScreen.verify:
        _verifyPin();
        break;
    }

    onClear();
  }

  Future<void> _verifyPin() async {
    final pinBox = ref.read(pinBoxProvider);
    final pinStorage = PinStorageService(pinBox);
    final verified = pinStorage.verifyPin(state.confirmPin);
    if (!verified) {
      state = state.copyWith(
        toastType: ToastType.error,
        message: 'Invalid passcode. Try again.',
      );
      return;
    }

    _unlockSession();
  }

  Future<void> authenticateWithBiometric() async {
    if (!state.isBiometricEnabled) return;

    final result = await FingerprintServices.instance.authenticate();
    if (result != AuthResult.success) {
      state = state.copyWith(
        toastType: ToastType.error,
        message: 'Biometric authentication failed. Try again.',
      );
      return;
    }

    _unlockSession();
  }

  Future<void> _savePin() async {
    if (state.createdPin != state.confirmPin) {
      state = state.copyWith(
        toastType: ToastType.error,
        message: 'Passcodes do not match. Try again.',
      );
      return;
    }

    final pinBox = ref.read(pinBoxProvider);
    final pinStorage = PinStorageService(pinBox);
    final saved = await pinStorage.savePin(state.confirmPin);
    if (!saved) {
      state = state.copyWith(
        toastType: ToastType.error,
        message: 'Could not save passcode. Please try again.',
      );
      return;
    }

    final profile = ref.read(profileNotifier).value?.isPasscodeEnabled ?? true;
    if (!profile) {
      await ref.read(profileNotifier.notifier).save(isPasscodeEnabled: true);
    }

    state = state.copyWith(
      toastType: ToastType.success,
      message: 'Passcodes updated successfully',
    );
  }

  void resetError() {
    state = state.copyWith(toastType: ToastType.normal);
  }
}

final authProvider = StateNotifierProvider.autoDispose<AuthProvider, AuthState>(
  (ref) => AuthProvider(ref),
);
