import 'dart:developer';

import 'package:finpal/app/app.dart';

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
    log("${options?.options.length}");
    if (options == null) return;

    await options.save(option);
    state = AsyncData(options);
  }

  Future<void> saveAllOptions(List<OptionModel> newOptions) async {
    final options = state.value;
    log("${options?.options.length}");
    if (options == null) return;

    await options.saveAll(newOptions);
    state = AsyncData(options);
  }

  Future<void> deleteOption(String id) async {
    final options = state.value;
    log("${options?.options.length}");
    if (options == null) return;

    await options.delete(id);
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
  final TextEditingController nameController;
  final bool isSaved;
  final bool hasError;

  OptionState({
    this.id,
    required this.icon,
    required this.name,
    required this.nameController,
    required this.isSaved,
    required this.hasError,
  });

  factory OptionState.initial() => OptionState(
    icon: '',
    name: '',
    nameController: TextEditingController(),
    isSaved: false,
    hasError: false,
  );

  OptionState copyWith({
    String? id,
    String? icon,
    String? name,
    bool? isSaved,
    bool? hasError,
  }) => OptionState(
    id: id ?? this.id,
    icon: icon ?? this.icon,
    name: name ?? this.name,
    nameController: nameController,
    isSaved: isSaved ?? this.isSaved,
    hasError: hasError ?? this.hasError,
  );
}

class OptionProvider extends StateNotifier<OptionState> {
  final Ref _ref;
  final String _type;
  OptionProvider(this._ref, this._type) : super(OptionState.initial());

  void loadData(String id) {
    if (id.isNotEmpty) {
      final option = _ref.read(optionNotifer).value?.findById(id);
      if (option != null) {
        state = state.copyWith(
          id: option.id,
          icon: option.icon,
          name: option.name,
        );
        state.nameController.text = option.name;
      }
    }
  }

  void setIcon(String icon) {
    state = state.copyWith(icon: icon);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  Future<void> save() async {
    state = state.copyWith(isSaved: false, hasError: false);
    final checkOption = _ref
        .read(optionNotifer)
        .value
        ?.findByName(state.name, _type);
    log("checkOption: $checkOption");
    if (checkOption != null) {
      state = state.copyWith(hasError: true);
      return;
    }

    final option = OptionModel(
      id: state.id,
      type: _type,
      icon: state.icon,
      name: state.name.trim(),
    );
    await _ref.read(optionNotifer.notifier).saveOption(option);
    if (!mounted) return;
    state = state.copyWith(isSaved: true);
    reset();
  }

  void reset() {
    state = state.copyWith(icon: '', name: '', isSaved: true);
    state.nameController.clear();
  }
}

final optionProvider = StateNotifierProvider.family
    .autoDispose<OptionProvider, OptionState, String>(
      (ref, type) => OptionProvider(ref, type),
    );
