import 'package:finpal/app/app.dart';

part 'ai_model.g.dart';

@HiveType(typeId: 3)
enum ChatRole {
  @HiveField(0)
  user,
  @HiveField(1)
  assistant,
}

@HiveType(typeId: 4)
enum ChatMessageStatus {
  @HiveField(0)
  sent,
  @HiveField(1)
  error,
}

@HiveType(typeId: 5)
class ChatMessage {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final ChatRole role;
  @HiveField(2)
  final String text;
  @HiveField(3)
  final ChatMessageStatus status;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
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
