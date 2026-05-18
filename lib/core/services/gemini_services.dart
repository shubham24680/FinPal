import 'package:finpal/app/app.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiServices {
  static GeminiServices? _instance;
  GeminiServices._();
  static GeminiServices get instance => _instance ??= GeminiServices._();

  Future<String> generateText(List<ChatMessage> messages) async {
    final response = await GeminiConfig.model.generateContent(
      _buildContent(messages),
    );
    final text = response.text;
    if (text == null) {
      throw Exception("Failed to generate text");
    }
    return text;
  }

  List<Content> _buildContent(List<ChatMessage> messages) {
    final systemPrompt = Content.text(GeminiConfig.financeSystemPrompt);
    final messagesContent =
        messages.reversed.map((e) => Content.text(e.text)).toList();
    return [systemPrompt, ...messagesContent];
  }
}
