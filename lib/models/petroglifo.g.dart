// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'petroglifo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PetroglifoAdapter extends TypeAdapter<Petroglifo> {
  @override
  final int typeId = 1;

  @override
  Petroglifo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Petroglifo(
      id: fields[0] as String,
      codigo: fields[1] as String,
      sitioId: fields[2] as String,
      tipoRoca: fields[3] as String,
      dimensiones: fields[4] as String,
      tecnicaGrabado: fields[5] as String,
      tipoMotivo: fields[6] as TipoMotivo,
      descripcion: fields[7] as String,
      estado: fields[8] as EstadoConservacion,
      visibilidad: fields[9] as Visibilidad,
      imagenPrincipal: fields[10] as String?,
      imagenesPublicas: (fields[11] as List?)?.cast<String>(),
      estaActivo: fields[12] as bool,
      fechaRegistro: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Petroglifo obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.codigo)
      ..writeByte(2)
      ..write(obj.sitioId)
      ..writeByte(3)
      ..write(obj.tipoRoca)
      ..writeByte(4)
      ..write(obj.dimensiones)
      ..writeByte(5)
      ..write(obj.tecnicaGrabado)
      ..writeByte(6)
      ..write(obj.tipoMotivo)
      ..writeByte(7)
      ..write(obj.descripcion)
      ..writeByte(8)
      ..write(obj.estado)
      ..writeByte(9)
      ..write(obj.visibilidad)
      ..writeByte(10)
      ..write(obj.imagenPrincipal)
      ..writeByte(11)
      ..write(obj.imagenesPublicas)
      ..writeByte(12)
      ..write(obj.estaActivo)
      ..writeByte(13)
      ..write(obj.fechaRegistro);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetroglifoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TipoMotivoAdapter extends TypeAdapter<TipoMotivo> {
  @override
  final int typeId = 10;

  @override
  TipoMotivo read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TipoMotivo.geometrico;
      case 1:
        return TipoMotivo.zoomorfo;
      case 2:
        return TipoMotivo.antropomorfo;
      case 3:
        return TipoMotivo.abstracto;
      case 4:
        return TipoMotivo.noIdentificado;
      default:
        return TipoMotivo.geometrico;
    }
  }

  @override
  void write(BinaryWriter writer, TipoMotivo obj) {
    switch (obj) {
      case TipoMotivo.geometrico:
        writer.writeByte(0);
        break;
      case TipoMotivo.zoomorfo:
        writer.writeByte(1);
        break;
      case TipoMotivo.antropomorfo:
        writer.writeByte(2);
        break;
      case TipoMotivo.abstracto:
        writer.writeByte(3);
        break;
      case TipoMotivo.noIdentificado:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipoMotivoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EstadoConservacionAdapter extends TypeAdapter<EstadoConservacion> {
  @override
  final int typeId = 11;

  @override
  EstadoConservacion read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EstadoConservacion.muyBueno;
      case 1:
        return EstadoConservacion.bueno;
      case 2:
        return EstadoConservacion.regular;
      case 3:
        return EstadoConservacion.malo;
      case 4:
        return EstadoConservacion.critico;
      default:
        return EstadoConservacion.muyBueno;
    }
  }

  @override
  void write(BinaryWriter writer, EstadoConservacion obj) {
    switch (obj) {
      case EstadoConservacion.muyBueno:
        writer.writeByte(0);
        break;
      case EstadoConservacion.bueno:
        writer.writeByte(1);
        break;
      case EstadoConservacion.regular:
        writer.writeByte(2);
        break;
      case EstadoConservacion.malo:
        writer.writeByte(3);
        break;
      case EstadoConservacion.critico:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EstadoConservacionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VisibilidadAdapter extends TypeAdapter<Visibilidad> {
  @override
  final int typeId = 12;

  @override
  Visibilidad read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Visibilidad.completa;
      case 1:
        return Visibilidad.basica;
      case 2:
        return Visibilidad.noMostrar;
      default:
        return Visibilidad.completa;
    }
  }

  @override
  void write(BinaryWriter writer, Visibilidad obj) {
    switch (obj) {
      case Visibilidad.completa:
        writer.writeByte(0);
        break;
      case Visibilidad.basica:
        writer.writeByte(1);
        break;
      case Visibilidad.noMostrar:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VisibilidadAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
