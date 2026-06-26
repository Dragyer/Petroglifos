import 'package:hive/hive.dart';

part 'usuario.g.dart';

@HiveType(typeId: 13)
enum RolUsuario {
  @HiveField(0)
  administrador,
  @HiveField(1)
  investigador,
}

@HiveType(typeId: 3)
class Usuario extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String nombre;

  @HiveField(2)
  String email;

  @HiveField(3)
  String run;

  @HiveField(4)
  RolUsuario rol;

  @HiveField(5)
  bool estaActivo;

  @HiveField(6)
  DateTime? fechaCreacion;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.run,
    required this.rol,
    this.estaActivo = true,
    DateTime? fechaCreacion,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now();

  bool get esAdmin => rol == RolUsuario.administrador;

  @override
  String toString() => '$nombre ($email)';
}