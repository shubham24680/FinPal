import 'package:finpal/app/app.dart';

final pinBoxProvider = Provider<Box<String>>(
  (ref) => throw UnimplementedError(),
);
final enableFingerprintProvider = StateProvider<bool>((ref) => false);

enum PinScreen {
  verify(
    [TypographyModel(text: "Protect your "),
      TypographyModel(text: "data.", color: AppColors.primary500)],
    "Please type in your passcode to continue",
  ),
  create(
    [TypographyModel(text: "Create your "),
      TypographyModel(text: "PIN.", color: AppColors.primary500)],
    "Use a 6-digit PIN for quick and safe access."
  ),
  confirm(
    [TypographyModel(text: "Confirm your "),
      TypographyModel(text: "PIN.", color: AppColors.primary500)],
    "Re-enter your passcode to confirm",
  );

  const PinScreen(this.header, this.description);
  final List<TypographyModel> header;
  final String description;
}

class AuthState {
  final PinScreen step;
  final String confirmPin, createdPin, oldPin;
  final ToastType toastType;
  final String? message;
  final bool isBiometricEnabled;
  final bool isUnlocked;

  AuthState({
    required this.step,
    required this.confirmPin,
    required this.oldPin,
    required this.toastType,
    this.message,
    required this.createdPin,
    required this.isBiometricEnabled,
    this.isUnlocked = false,
  });

  factory AuthState.initial() => AuthState(
    step: PinScreen.create,
    confirmPin: '',
    createdPin: '',
    oldPin: '',
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
    bool? isBiometricEnabled,
    bool? isUnlocked,
  }) => AuthState(
    step: step ?? this.step,
    confirmPin: confirmPin ?? this.confirmPin,
    createdPin: createdPin ?? this.createdPin,
    oldPin: oldPin ?? this.oldPin,
    toastType: toastType ?? this.toastType,
    message: message,
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
      step: PinScreen.verify,
      isBiometricEnabled: false,
      // step: profile.isPasscodeEnabled ? PinScreen.verify : PinScreen.create,
      // isBiometricEnabled: profile.isFingerprintEnabled,
    );
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

  void _unlockSession() {
    if (AppRoutes.isAppLocked) {
      AppRoutes.isAppLocked = false;
      state = state.copyWith(isUnlocked: true);
      return;
    }

    state = state.copyWith(step: PinScreen.create);
    onClear();
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

    final settings = ref.read(settingsNotifier).value;
    final isPasscodeEnabled = settings?.isPasscodeEnabled ?? true;
    if (!isPasscodeEnabled) {
      await ref.read(settingsNotifier.notifier).save(isPasscodeEnabled: true);
    }

    state = state.copyWith(
      toastType: ToastType.success,
      message: 'Passcodes updated successfully',
    );

    _unlockSession();
  }

  void resetError() {
    state = state.copyWith(toastType: ToastType.normal);
  }
}

final authProvider = StateNotifierProvider.autoDispose<AuthProvider, AuthState>(
  (ref) => AuthProvider(ref),
);
