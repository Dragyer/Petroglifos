import 'package:hive/hive.dart';

part 'petroglifo.g.dart';

// ─────────────────────────────────────────────
// Enums (typeId 10, 11, 12)
// ─────────────────────────────────────────────

@HiveType(typeId: 10)
enum TipoMotivo {
  @HiveField(0)
  geometrico,
  @HiveField(1)
  zoomorfo,
  @HiveField(2)
  antropomorfo,
  @HiveField(3)
  abstracto,
  @HiveField(4)
  noIdentificado,
}

@HiveType(typeId: 11)
enum EstadoConservacion {
  @HiveField(0)
  muyBueno,
  @HiveField(1)
  bueno,
  @HiveField(2)
  regular,
  @HiveField(3)
  malo,
  @HiveField(4)
  critico,
}

@HiveType(typeId: 12)
enum Visibilidad {
  @HiveField(0)
  completa,
  @HiveField(1)
  basica,
  @HiveField(2)
  noMostrar,
}

// ─────────────────────────────────────────────
// Modelo principal
// ─────────────────────────────────────────────

@HiveType(typeId: 1)
class Petroglifo extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String codigo;

  @HiveField(2)
  String sitioId;

  @HiveField(3)
  String tipoRoca;

  @HiveField(4)
  String dimensiones;

  @HiveField(5)
  String tecnicaGrabado;

  @HiveField(6)
  TipoMotivo tipoMotivo;

  @HiveField(7)
  String descripcion;

  @HiveField(8)
  EstadoConservacion estado;

  @HiveField(9)
  Visibilidad visibilidad;

  @HiveField(10)
  String? imagenPrincipal;

  @HiveField(11)
  List<String> imagenesPublicas;

  @HiveField(12)
  bool estaActivo;

  @HiveField(13)
  DateTime? fechaRegistro;

  Petroglifo({
    required this.id,
    required this.codigo,
    required this.sitioId,
    required this.tipoRoca,
    required this.dimensiones,
    required this.tecnicaGrabado,
    required this.tipoMotivo,
    required this.descripcion,
    required this.estado,
    required this.visibilidad,
    this.imagenPrincipal,
    List<String>? imagenesPublicas,
    this.estaActivo = true,
    DateTime? fechaRegistro,
  })  : imagenesPublicas = imagenesPublicas ?? [],
        fechaRegistro = fechaRegistro ?? DateTime.now();

  // ── Helpers de display ──────────────────────

  String get estadoTexto {
    switch (estado) {
      case EstadoConservacion.muyBueno:
        return 'Muy bueno';
      case EstadoConservacion.bueno:
        return 'Bueno';
      case EstadoConservacion.regular:
        return 'Regular';
      case EstadoConservacion.malo:
        return 'Malo';
      case EstadoConservacion.critico:
        return 'Crítico';
    }
  }

  String get tipoMotivoTexto {
    switch (tipoMotivo) {
      case TipoMotivo.geometrico:
        return 'Geométrico';
      case TipoMotivo.zoomorfo:
        return 'Zoomorfo';
      case TipoMotivo.antropomorfo:
        return 'Antropomorfo';
      case TipoMotivo.abstracto:
        return 'Abstracto';
      case TipoMotivo.noIdentificado:
        return 'No identificado';
    }
  }

  bool get esVisible =>
      visibilidad == Visibilidad.completa || visibilidad == Visibilidad.basica;

  @override
  String toString() => codigo;
}