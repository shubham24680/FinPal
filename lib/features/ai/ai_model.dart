import 'package:uuid/uuid.dart';

enum ChatRole { user, assistant }

enum ChatMessageStatus { sent, error }

class ChatMessage {
  final String id;
  final ChatRole role;
  final String text;
  final ChatMessageStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ChatMessage({
    required this.text,
    this.role = ChatRole.user,
    this.status = ChatMessageStatus.sent,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? Uuid().v7(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  ChatMessage copyWith({String? text, ChatMessageStatus? status}) =>
      ChatMessage(
        id: id,
        role: role,
        text: text ?? this.text,
        status: status ?? this.status,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );
}
