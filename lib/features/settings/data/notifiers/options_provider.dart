import 'dart:developer';
import 'package:finpal/app/app.dart';

final selectedOptionProvider = StateProvider<OptionModel?>((ref) => null);

final optionBoxProvider = Provider<Box<OptionModel>>(
  (ref) => throw UnimplementedError(),
);

class OptionNotifier extends AsyncNotifier<OptionServices> {
  @override
  Future<OptionServices> build() async {
    final box = ref.watch(optionBoxProvider);
    return OptionServices(box);
  }

  Future<void> saveOption(OptionModel option) async {
    final options = state.value;
    log("${options?.categories.length}");
    if (options == null) return;

    await options.save(option);
    state = AsyncData(options);
  }

  Future<void> saveAllOptions(List<OptionModel> newOptions) async {
    final options = state.value;
    log("${options?.categories.length}");
    if (options == null) return;

    await options.saveAll(newOptions);
    state = AsyncData(options);
  }

  Future<void> deleteOption(String id) async {
    final options = state.value;
    log("${options?.categories.length}");
    if (options == null) return;

    await options.delete(id);
    state = AsyncData(options);
  }

  Future<void> clearData() async {
    final options = state.value;
    log("${options?.categories.length}");
    if (options == null) return;

    await options.clearData();
    state = AsyncData(options);
  }
}

final optionNotifer = AsyncNotifierProvider<OptionNotifier, OptionServices>(
  () => OptionNotifier(),
);

class OptionState {
  final String? id;
  final String icon;
  final String name;
  final ColorSet color;
  final OptionType? type;
  final ButtonState buttonState;
  final ToastType toastType;
  final String message;

  OptionState({
    this.id,
    required this.icon,
    required this.name,
    required this.color,
    this.type,
    required this.buttonState,
    required this.toastType,
    required this.message,
  });

  factory OptionState.initial() => OptionState(
    icon: AppSvgs.add1,
    name: '',
    color: ColorSet.primary,
    buttonState: ButtonState.disabled,
    toastType: ToastType.normal,
    message: '',
  );

  OptionState copyWith({
    String? id,
    String? icon,
    String? name,
    ColorSet? color,
    OptionType? type,
    ButtonState? buttonState,
    ToastType? toastType,
    String? message,
  }) => OptionState(
    id: id ?? this.id,
    icon: icon ?? this.icon,
    name: name ?? this.name,
    color: color ?? this.color,
    type: type ?? this.type,
    buttonState: buttonState ?? this.buttonState,
    toastType: toastType ?? this.toastType,
    message: message ?? this.message,
  );
}

class OptionProvider extends StateNotifier<OptionState> {
  final Ref _ref;
  OptionProvider(this._ref) : super(OptionState.initial()) {
    _loadData();
  }

  void _loadData() {
    final selectedOption = _ref.read(selectedOptionProvider);
    if (selectedOption == null) return;
    state = state.copyWith(
      id: selectedOption.id.isNotEmpty ? selectedOption.id : null,
      icon: selectedOption.icon,
      name: selectedOption.name,
      color: selectedOption.color.colorSet,
      type: selectedOption.type.byId,
    );
  }

  void set({
    String? id,
    String? icon,
    String? name,
    ColorSet? color,
    OptionType? type,
  }) {
    state = state.copyWith(
      id: id ?? state.id,
      icon: icon ?? state.icon,
      name: name ?? state.name,
      color: color ?? state.color,
      type: type ?? state.type,
    );
    onChange();
  }

  void onChange() {
    final isValid = state.name.isNotEmpty && state.type != null;
    state = state.copyWith(
      buttonState: isValid ? ButtonState.enabled : ButtonState.disabled,
    );
  }

  Future<void> save() async {
    state = state.copyWith(buttonState: ButtonState.loading);
    try {
      final typeId = state.type?.id;
      if (typeId == null) {
        state = state.copyWith(
          toastType: ToastType.error,
          message: "Please select a category type",
        );
        return;
      }

      final isDuplicate =
          _ref
              .read(optionNotifer)
              .value
              ?.existsByName(state.name, typeId, excludeId: state.id) ??
          false;
      if (isDuplicate) {
        state = state.copyWith(
          toastType: ToastType.error,
          message: "Option already exists",
        );
        return;
      }

      final option = OptionModel(
        id: state.id,
        type: typeId,
        icon: state.icon,
        name: state.name.trim(),
        color: state.color.name,
      );
      await _ref.read(optionNotifer.notifier).saveOption(option);
      state = state.copyWith(
        toastType: ToastType.success,
        message: "Option saved successfully",
      );
    } catch (e, stack) {
      log("Failed to save option", error: e, stackTrace: stack);
      state = state.copyWith(
        toastType: ToastType.error,
        message: "Failed to save option",
      );
    } finally {
      state = state.copyWith(buttonState: ButtonState.enabled);
    }
  }

  void resetToast() {
    state = state.copyWith(toastType: ToastType.normal, message: '');
  }
}

final optionProvider =
    StateNotifierProvider.autoDispose<OptionProvider, OptionState>(
      (ref) => OptionProvider(ref),
    );
