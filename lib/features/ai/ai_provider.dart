import 'package:finpal/app/app.dart';

class AiState {
  final TextEditingController inputController;
  final ScrollController scrollController;
  final String inputText;
  final bool waiting;
  final List<AiModel> messages;

  AiState({
    required this.inputController,
    required this.scrollController,
    required this.inputText,
    required this.waiting,
    required this.messages,
  });

  factory AiState.initial() => AiState(
    inputController: TextEditingController(),
    scrollController: ScrollController(),
    inputText: '',
    waiting: false,
    messages: [],
  );

  AiState copyWith({
    String? inputText,
    bool? waiting,
    List<AiModel>? messages,
  }) => AiState(
    inputController: inputController,
    scrollController: scrollController,
    inputText: inputText ?? this.inputText,
    waiting: waiting ?? this.waiting,
    messages: messages ?? this.messages,
  );
}

class AiNotifier extends StateNotifier<AiState> {
  AiNotifier() : super(AiState.initial());

  void setWaiting(bool waiting) => state = state.copyWith(waiting: waiting);

  void setInputText(String? inputText) =>
      state = state.copyWith(inputText: inputText);

  void send() {
    final text = state.inputText.trim();
    if (text.isEmpty || state.waiting) return;
    state = state.copyWith(
      waiting: true,
      messages: [...state.messages, AiModel(isUser: true, text: text)],
    );
    resetInputText();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      state = state.copyWith(
        waiting: false,
        messages: [
          ...state.messages,
          AiModel(isUser: false, text: 'I received: “$text”'),
        ],
      );
    });
  }

  void resetInputText() {
    state = state.copyWith(inputText: '');
    state.inputController.clear();
    if (!state.scrollController.hasClients) return;
    state.scrollController.animateTo(
      state.scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
    );
  }
}

final aiProvider = StateNotifierProvider.autoDispose<AiNotifier, AiState>(
  (ref) => AiNotifier(),
);
