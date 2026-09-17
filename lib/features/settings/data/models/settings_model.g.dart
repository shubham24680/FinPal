// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 0;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      id: fields[0] as String?,
      isFirstVisit: fields[1] == null ? true : fields[1] as bool,
      isFingerprintEnabled: fields[2] == null ? false : fields[2] as bool,
      isPasscodeEnabled: fields[3] == null ? false : fields[3] as bool,
      currencyCode: fields[4] == null ? 'INR' : fields[4] as String,
      currencySymbol: fields[5] == null ? '₹' : fields[5] as String,
      languageCode: fields[6] == null ? 'en' : fields[6] as String,
      themeMode: fields[7] == null ? 'system' : fields[7] as String,
      hideBalanceOnHome: fields[8] == null ? false : fields[8] as bool,
      dailyReminderEnabled: fields[9] == null ? false : fields[9] as bool,
      dailyReminderTime: fields[10] as DateTime?,
      monthlyBudget: fields[11] == null ? 0 : fields[11] as double,
      aiInsightsEnabled: fields[12] == null ? false : fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isFirstVisit)
      ..writeByte(2)
      ..write(obj.isFingerprintEnabled)
      ..writeByte(3)
      ..write(obj.isPasscodeEnabled)
      ..writeByte(4)
      ..write(obj.currencyCode)
      ..writeByte(5)
      ..write(obj.currencySymbol)
      ..writeByte(6)
      ..write(obj.languageCode)
      ..writeByte(7)
      ..write(obj.themeMode)
      ..writeByte(8)
      ..write(obj.hideBalanceOnHome)
      ..writeByte(9)
      ..write(obj.dailyReminderEnabled)
      ..writeByte(10)
      ..write(obj.dailyReminderTime)
      ..writeByte(11)
      ..write(obj.monthlyBudget)
      ..writeByte(12)
      ..write(obj.aiInsightsEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
