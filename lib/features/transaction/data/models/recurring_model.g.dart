// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurringModelAdapter extends TypeAdapter<RecurringModel> {
  @override
  final int typeId = 6;

  @override
  RecurringModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurringModel(
      id: fields[0] as String?,
      frequency: fields[1] == null ? 0 : fields[1] as int,
      isActive: fields[2] == null ? false : fields[2] as bool,
      date: fields[3] as DateTime?,
      interval: fields[4] == null ? 'daily' : fields[4] as String,
      endType: fields[5] == null ? 'never' : fields[5] as String,
      endDate: fields[6] as DateTime?,
      lastPaymentDate: fields[7] as DateTime?,
      nextPaymentDate: fields[8] as DateTime?,
      createdAt: fields[9] as DateTime?,
      updatedAt: fields[10] as DateTime?,
      paymentType: fields[11] as String,
      amount: fields[12] as double,
      categoryId: fields[13] as String?,
      paymentMethodId: fields[14] as String?,
      notes: fields[15] as String,
      receiptPath: fields[16] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecurringModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.frequency)
      ..writeByte(2)
      ..write(obj.isActive)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.interval)
      ..writeByte(5)
      ..write(obj.endType)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.lastPaymentDate)
      ..writeByte(8)
      ..write(obj.nextPaymentDate)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.paymentType)
      ..writeByte(12)
      ..write(obj.amount)
      ..writeByte(13)
      ..write(obj.categoryId)
      ..writeByte(14)
      ..write(obj.paymentMethodId)
      ..writeByte(15)
      ..write(obj.notes)
      ..writeByte(16)
      ..write(obj.receiptPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
