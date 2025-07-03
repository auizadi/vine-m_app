// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diseases_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DetectionHistoryAdapter extends TypeAdapter<DetectionHistory> {
  @override
  final int typeId = 0;

  @override
  DetectionHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DetectionHistory(
      className: fields[0] as String,
      confidence: fields[1] as double,
      imagePath: fields[2] as String,
      detectionTime: fields[3] as DateTime,
      isSaved: fields[4] as bool,
      isFirstLaunch: fields[5] as bool,
      userName: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DetectionHistory obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.className)
      ..writeByte(1)
      ..write(obj.confidence)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.detectionTime)
      ..writeByte(4)
      ..write(obj.isSaved)
      ..writeByte(5)
      ..write(obj.isFirstLaunch)
      ..writeByte(6)
      ..write(obj.userName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetectionHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
