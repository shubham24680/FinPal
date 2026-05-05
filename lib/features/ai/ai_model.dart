class AiModel {
  final bool isUser;
  final String text;
  final DateTime createdAt;

  AiModel({this.isUser = false, required this.text, DateTime? createdAt})
    : createdAt = createdAt ?? DateTime.now();

  AiModel copyWith({bool? isUser, String? text, DateTime? createdAt}) =>
      AiModel(
        isUser: isUser ?? this.isUser,
        text: text ?? this.text,
        createdAt: createdAt ?? DateTime.now(),
      );
}
