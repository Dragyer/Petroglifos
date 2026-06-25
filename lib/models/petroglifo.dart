import 'package:hive/hive.dart';

part 'petroglifo.g.dart';

@HiveType(typeId: 1)
class Petroglifo {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String codigo;

  @HiveField(2)
  final String sitioId;

  @HiveField(3)
  final String tipoRoca;

  @HiveField(4)
  final String dimensiones;

  @HiveField(5)
  final String tecnicaGrabado;

  @HiveField(6)
  final TipoMotivo tipoMotivo;

  @HiveField(7)
  final String descripcion;

  @HiveField(8)
  final EstadoConservacion estado;

  @HiveField(9)
  final Visibilidad visibilidad;

  @HiveField(10)
  final String? imagenPrincipal;

  @HiveField(11)
  final List<String> imagenesPublicas;

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
    this.visibilidad = Visibilidad.basica,
    this.imagenPrincipal,
    this.imagenesPublicas = const [],
  });

  String get estadoTexto {
    switch (estado) {
      case EstadoConservacion.muyBueno:
        return 'Muy Bueno';
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

  factory Petroglifo.fromJson(Map<String, dynamic> json) => Petroglifo(
        id: json['id'],
        codigo: json['codigo'],
        sitioId: json['sitioId'],
        tipoRoca: json['tipoRoca'],
        dimensiones: json['dimensiones'],
        tecnicaGrabado: json['tecnicaGrabado'],
        tipoMotivo: TipoMotivo.values[json['tipoMotivo']],
        descripcion: json['descripcion'],
        estado: EstadoConservacion.values[json['estado']],
        visibilidad: Visibilidad.values[json['visibilidad'] ?? 1],
        imagenPrincipal: json['imagenPrincipal'],
        imagenesPublicas: List<String>.from(json['imagenesPublicas'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'codigo': codigo,
        'sitioId': sitioId,
        'tipoRoca': tipoRoca,
        'dimensiones': dimensiones,
        'tecnicaGrabado': tecnicaGrabado,
        'tipoMotivo': tipoMotivo.index,
        'descripcion': descripcion,
        'estado': estado.index,
        'visibilidad': visibilidad.index,
        'imagenPrincipal': imagenPrincipal,
        'imagenesPublicas': imagenesPublicas,
      };

  Petroglifo copyWith({
    String? codigo,
    String? tipoRoca,
    String? dimensiones,
    String? tecnicaGrabado,
    TipoMotivo? tipoMotivo,
    String? descripcion,
    EstadoConservacion? estado,
    Visibilidad? visibilidad,
    String? imagenPrincipal,
    List<String>? imagenesPublicas,
  }) {
    return Petroglifo(
      id: id,
      codigo: codigo ?? this.codigo,
      sitioId: sitioId,
      tipoRoca: tipoRoca ?? this.tipoRoca,
      dimensiones: dimensiones ?? this.dimensiones,
      tecnicaGrabado: tecnicaGrabado ?? this.tecnicaGrabado,
      tipoMotivo: tipoMotivo ?? this.tipoMotivo,
      descripcion: descripcion ?? this.descripcion,
      estado: estado ?? this.estado,
      visibilidad: visibilidad ?? this.visibilidad,
      imagenPrincipal: imagenPrincipal ?? this.imagenPrincipal,
      imagenesPublicas: imagenesPublicas ?? this.imagenesPublicas,
    );
  }
}

// ==================== ENUMS CON HIVE ====================

@HiveType(typeId: 2)
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

@HiveType(typeId: 3)
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

@HiveType(typeId: 4)
enum Visibilidad {
  @HiveField(0)
  completa,
  @HiveField(1)
  basica,
  @HiveField(2)
  no,
}