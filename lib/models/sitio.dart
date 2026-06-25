import 'package:hive/hive.dart';

part 'sitio.g.dart';

@HiveType(typeId: 0)
class Sitio {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nombre;

  @HiveField(2)
  final String codigo;

  @HiveField(3)
  final String comuna;

  @HiveField(4)
  final String descripcion;

  @HiveField(5)
  final double lat;

  @HiveField(6)
  final double lng;

  @HiveField(7)
  final bool esRestringido;

  Sitio({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.comuna,
    required this.descripcion,
    required this.lat,
    required this.lng,
    this.esRestringido = true,
  });

  // Constructor desde JSON (útil para migraciones o backups)
  factory Sitio.fromJson(Map<String, dynamic> json) => Sitio(
        id: json['id'],
        nombre: json['nombre'],
        codigo: json['codigo'],
        comuna: json['comuna'],
        descripcion: json['descripcion'],
        lat: json['lat'].toDouble(),
        lng: json['lng'].toDouble(),
        esRestringido: json['esRestringido'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'codigo': codigo,
        'comuna': comuna,
        'descripcion': descripcion,
        'lat': lat,
        'lng': lng,
        'esRestringido': esRestringido,
      };

  Sitio copyWith({
    String? nombre,
    String? codigo,
    String? comuna,
    String? descripcion,
    double? lat,
    double? lng,
    bool? esRestringido,
  }) {
    return Sitio(
      id: id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      comuna: comuna ?? this.comuna,
      descripcion: descripcion ?? this.descripcion,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      esRestringido: esRestringido ?? this.esRestringido,
    );
  }
}