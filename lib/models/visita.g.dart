// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visita.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VisitaAdapter extends TypeAdapter<Visita> {
  @override
  final int typeId = 2;

  @override
  Visita read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Visita(
      id: fields[0] as String,
      sitioId: fields[1] as String,
      investigadorId: fields[2] as String,
      fecha: fields[3] as DateTime,
      observaciones: fields[4] as String,
      hallazgos: (fields[5] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Visita obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.sitioId)
      ..writeByte(2)
      ..write(obj.investigadorId)
      ..writeByte(3)
      ..write(obj.fecha)
      ..writeByte(4)
      ..write(obj.observaciones)
      ..writeByte(5)
      ..write(obj.hallazgos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisitaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
