import 'dart:developer';

import 'package:finpal/app/app.dart';

final aiBoxProvider = Provider<Box<ChatMessage>>(
  (ref) => throw UnimplementedError(),
);

class AiNotifier extends AsyncNotifier<AiService> {
  @override
  Future<AiService> build() async {
    final box = ref.watch(aiBoxProvider);
    return AiService(box);
  }

  Future<void> sendMessage(String message) async {
    final service = state.value;
    if (service == null) return;

    await service.save(ChatMessage(role: ChatRole.user, text: message));
    state = AsyncData(service);
    await sendAssistantMessage();
  }

  Future<void> sendAssistantMessage() async {
    final service = state.value;
    if (service == null) return;

    state = const AsyncLoading<AiService>().copyWithPrevious(state);

    state = await AsyncValue.guard(() async {
      await service.generateText();
      return service;
    });
  }

  Future<void> editMessage(String id, String text) async {
    final service = state.value;
    if (service == null) return;

    await service.deleteAll(id);
    state = AsyncData(service);
    await sendMessage(text);
  }

  Future<void> retryMessage(ChatMessage message) async {
    final service = state.value;
    if (service == null) return;

    await service.deleteAll(message.id);
    state = AsyncData(service);
    await sendAssistantMessage();
  }

  Future<void> clearAll() async {
    await state.value?.clearAll();
  }
}

final aiNotifer = AsyncNotifierProvider<AiNotifier, AiService>(
  () => AiNotifier(),
);

enum AiMode { normal, editing }

class AiState {
  final TextEditingController inputController;
  final String inputText;
  final AiMode mode;
  final List<ChatMessage> messages;
  final String replaceId;

  AiState({
    required this.inputController,
    required this.inputText,
    required this.mode,
    required this.messages,
    required this.replaceId,
  });

  factory AiState.initial() => AiState(
    inputController: TextEditingController(),
    inputText: '',
    mode: AiMode.normal,
    messages: const [],
    replaceId: "",
  );

  AiState copyWith({
    String? inputText,
    AiMode? mode,
    List<ChatMessage>? messages,
    String? replaceId,
  }) => AiState(
    inputController: inputController,
    inputText: inputText ?? this.inputText,
    mode: mode ?? this.mode,
    messages: messages ?? this.messages,
    replaceId: replaceId ?? this.replaceId,
  );
}

class AiProvider extends StateNotifier<AiState> {
  final Ref ref;
  AiProvider(this.ref) : super(AiState.initial());

  void setInputText(String inputText) {
    if (state.inputText == inputText) return;
    state = state.copyWith(inputText: inputText);
  }

  void update(ChatMessage message) {
    state = state.copyWith(
      replaceId: message.id,
      inputText: message.text,
      mode: AiMode.editing,
    );
    state.inputController.text = message.text;
    log(
      "Message updated: ${message.text}, id: ${message.id}",
      name: "AiProvider",
    );
  }

  void clearEditing() {
    state = state.copyWith(replaceId: "", mode: AiMode.normal);
    _clearInput();
  }

  Future<void> retryMessage(ChatMessage message) async {
    await ref.read(aiNotifer.notifier).retryMessage(message);
  }

  Future<void> send() async {
    final text = state.inputText.trim();
    if (text.isEmpty) return;
    _clearInput();

    if (state.replaceId.isNotEmpty) {
      log("Editing message: ${state.replaceId}", name: "AiProvider");
      await ref.read(aiNotifer.notifier).editMessage(state.replaceId, text);
      clearEditing();
    } else {
      log("Sending message: $text", name: "AiProvider");
      await ref.read(aiNotifer.notifier).sendMessage(text);
    }
  }

  void _clearInput() {
    state = state.copyWith(inputText: '');
    state.inputController.clear();
  }
}

final aiProvider = StateNotifierProvider.autoDispose<AiProvider, AiState>(
  (ref) => AiProvider(ref),
);
