import 'dart:developer';

import 'package:finpal/app/app.dart';

class AiService {
  final Box<ChatMessage> box;
  late final HiveService<ChatMessage> _hiveService;
  static const maxMessages = 20;

  AiService(this.box) {
    _hiveService = HiveService<ChatMessage>(box);
  }

  List<ChatMessage> get messages => _hiveService.getAllData();
  List<ChatMessage> get getMessages {
    final all = messages;
    final recent =
        all.length > maxMessages ? all.sublist(all.length - maxMessages) : all;
    return recent.reversed.toList();
  }

  Future<void> save(ChatMessage message) async {
    await _hiveService.saveData(message.id, message);
    log("Message saved: ${message.id}", name: "AiService");
  }

  Future<void> deleteAll(String id) async {
    final all = messages;
    final index = all.indexWhere((e) => e.id == id);
    if (index < 0) return;

    final idsToDelete = all.sublist(index).map((e) => e.id).toList();
    for (final messageId in idsToDelete) {
      await _hiveService.clearData(messageId);
      log("Message deleted: $messageId", name: "AiService");
    }
  }

  Future<void> generateText() async {
    try {
      final response = await GeminiServices.instance.generateText(getMessages);
      await save(ChatMessage(role: ChatRole.assistant, text: response));
      log("Message generated: $response", name: "AiService");
    } catch (e, st) {
      await save(
        ChatMessage(
          role: ChatRole.assistant,
          text: "Something went wrong. Please try again.",
          status: ChatMessageStatus.error,
        ),
      );
      log('Gemini generate text failed', error: e, stackTrace: st);
    }
  }

  Future<void> clearAll() async {
    await _hiveService.clearAllData();
    log("All messages cleared", name: "AiService");
  }
}
