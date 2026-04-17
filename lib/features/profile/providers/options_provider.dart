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
}

final optionProvider = AsyncNotifierProvider<OptionNotifier, OptionServices>(
  () => OptionNotifier(),
);
