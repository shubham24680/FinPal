// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 5;

  @override
  ChatMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessage(
      text: fields[2] as String,
      role: fields[1] as ChatRole,
      status: fields[3] as ChatMessageStatus,
      id: fields[0] as String?,
      createdAt: fields[4] as DateTime?,
      updatedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatRoleAdapter extends TypeAdapter<ChatRole> {
  @override
  final int typeId = 3;

  @override
  ChatRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChatRole.user;
      case 1:
        return ChatRole.assistant;
      default:
        return ChatRole.user;
    }
  }

  @override
  void write(BinaryWriter writer, ChatRole obj) {
    switch (obj) {
      case ChatRole.user:
        writer.writeByte(0);
        break;
      case ChatRole.assistant:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatMessageStatusAdapter extends TypeAdapter<ChatMessageStatus> {
  @override
  final int typeId = 4;

  @override
  ChatMessageStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChatMessageStatus.sent;
      case 1:
        return ChatMessageStatus.error;
      default:
        return ChatMessageStatus.sent;
    }
  }

  @override
  void write(BinaryWriter writer, ChatMessageStatus obj) {
    switch (obj) {
      case ChatMessageStatus.sent:
        writer.writeByte(0);
        break;
      case ChatMessageStatus.error:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
