// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sitio.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SitioAdapter extends TypeAdapter<Sitio> {
  @override
  final int typeId = 0;

  @override
  Sitio read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sitio(
      id: fields[0] as String,
      nombre: fields[1] as String,
      codigo: fields[2] as String,
      comuna: fields[3] as String,
      descripcion: fields[4] as String,
      lat: fields[5] as double,
      lng: fields[6] as double,
      esRestringido: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Sitio obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.codigo)
      ..writeByte(3)
      ..write(obj.comuna)
      ..writeByte(4)
      ..write(obj.descripcion)
      ..writeByte(5)
      ..write(obj.lat)
      ..writeByte(6)
      ..write(obj.lng)
      ..writeByte(7)
      ..write(obj.esRestringido);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SitioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
