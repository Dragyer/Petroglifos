import 'package:hive/hive.dart';

part 'sitio.g.dart';

@HiveType(typeId: 0)
class Sitio extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String nombre;

  @HiveField(2)
  String codigo;

  @HiveField(3)
  String comuna;

  @HiveField(4)
  String descripcion;

  @HiveField(5)
  double lat;

  @HiveField(6)
  double lng;

  @HiveField(7)
  bool esRestringido;

  @HiveField(8)
  bool estaActivo;

  @HiveField(9)
  String? responsable;

  @HiveField(10)
  DateTime? fechaRegistro;

  Sitio({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.comuna,
    required this.descripcion,
    required this.lat,
    required this.lng,
    this.esRestringido = false,
    this.estaActivo = true,
    this.responsable,
    DateTime? fechaRegistro,
  }) : fechaRegistro = fechaRegistro ?? DateTime.now();

  /// Devuelve coordenadas visibles según restricción del sitio
  String get coordenadasPublicas =>
      esRestringido ? 'Coordenadas restringidas · $comuna' : '$lat, $lng';

  @override
  String toString() => '$codigo - $nombre';
}