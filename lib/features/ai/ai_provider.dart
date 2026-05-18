import 'dart:developer';
import 'package:finpal/app/app.dart';

enum AiMode { normal, waiting, editing }

class AiState {
  final TextEditingController inputController;
  final String inputText;
  final AiMode mode;
  final List<ChatMessage> messages;
  final String tempId;

  AiState({
    required this.inputController,
    required this.inputText,
    required this.mode,
    required this.messages,
    required this.tempId,
  });

  factory AiState.initial() => AiState(
    inputController: TextEditingController(),
    inputText: '',
    mode: AiMode.normal,
    messages: const [],
    tempId: '',
  );

  AiState copyWith({
    String? inputText,
    AiMode? mode,
    List<ChatMessage>? messages,
    String? tempId,
  }) => AiState(
    inputController: inputController,
    inputText: inputText ?? this.inputText,
    mode: mode ?? this.mode,
    messages: messages ?? this.messages,
    tempId: tempId ?? this.tempId,
  );
}

class AiNotifier extends StateNotifier<AiState> {
  AiNotifier() : super(AiState.initial());

  void setInputText(String inputText) {
    if (state.inputText == inputText) return;
    state = state.copyWith(inputText: inputText);
  }

  void setTempId(String tempId) => state = state.copyWith(tempId: tempId);

  void update(ChatMessage message) {
    state = state.copyWith(
      tempId: message.id,
      inputText: message.text,
      mode: AiMode.editing,
    );
    state.inputController.text = message.text;
  }

  void retry(ChatMessage message) {
    state = state.copyWith(tempId: message.id);
    final history = _historyForNextSend();
    state = state.copyWith(messages: history);
    _sendAssistantMessage(message.text);
  }

  Future<void> send() async {
    final text = state.inputText.trim();
    if (text.isEmpty || state.mode == AiMode.waiting) return;

    final history = _historyForNextSend();
    state = state.copyWith(
      mode: AiMode.waiting,
      tempId: '',
      messages: [ChatMessage(role: ChatRole.user, text: text), ...history],
    );
    _clearInput();
    _sendAssistantMessage(text);
  }

  Future<void> _sendAssistantMessage(String text) async {
    try {
      final response = await GeminiServices.instance.generateText(
        state.messages,
      );
      state = state.copyWith(
        mode: AiMode.normal,
        messages: [
          ChatMessage(role: ChatRole.assistant, text: response),
          ...state.messages,
        ],
      );
    } catch (e, st) {
      state.inputController.text = text;
      state = state.copyWith(
        mode: AiMode.normal,
        inputText: text,
        messages: [
          ChatMessage(
            role: ChatRole.assistant,
            status: ChatMessageStatus.error,
            text: "Something went wrong. Please try again.",
          ),
          ...state.messages,
        ],
      );
      log('Gemini send failed', error: e, stackTrace: st);
    }
  }

  List<ChatMessage> _historyForNextSend() {
    if (state.tempId.isNotEmpty) {
      final editIndex = state.messages.indexWhere((e) => e.id == state.tempId);
      if (editIndex < 0) return state.messages;
      return state.messages.sublist(editIndex + 1);
    }

    return state.messages;
  }

  void _clearInput() {
    state = state.copyWith(inputText: '');
    state.inputController.clear();
  }
}

final aiProvider = StateNotifierProvider.autoDispose<AiNotifier, AiState>(
  (ref) => AiNotifier(),
);
