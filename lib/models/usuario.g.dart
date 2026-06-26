// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsuarioAdapter extends TypeAdapter<Usuario> {
  @override
  final int typeId = 3;

  @override
  Usuario read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Usuario(
      id: fields[0] as String,
      nombre: fields[1] as String,
      email: fields[2] as String,
      run: fields[3] as String,
      rol: fields[4] as RolUsuario,
      estaActivo: fields[5] as bool,
      fechaCreacion: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Usuario obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.run)
      ..writeByte(4)
      ..write(obj.rol)
      ..writeByte(5)
      ..write(obj.estaActivo)
      ..writeByte(6)
      ..write(obj.fechaCreacion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsuarioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RolUsuarioAdapter extends TypeAdapter<RolUsuario> {
  @override
  final int typeId = 13;

  @override
  RolUsuario read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RolUsuario.administrador;
      case 1:
        return RolUsuario.investigador;
      default:
        return RolUsuario.administrador;
    }
  }

  @override
  void write(BinaryWriter writer, RolUsuario obj) {
    switch (obj) {
      case RolUsuario.administrador:
        writer.writeByte(0);
        break;
      case RolUsuario.investigador:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RolUsuarioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
