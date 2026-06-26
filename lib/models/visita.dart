import 'package:hive/hive.dart';

part 'visita.g.dart';

@HiveType(typeId: 2)
class Visita extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String sitioId;

  @HiveField(2)
  String investigadorId;

  @HiveField(3)
  DateTime fecha;

  @HiveField(4)
  String observaciones;

  @HiveField(5)
  List<String> hallazgos;

  Visita({
    required this.id,
    required this.sitioId,
    required this.investigadorId,
    required this.fecha,
    required this.observaciones,
    List<String>? hallazgos,
  }) : hallazgos = hallazgos ?? [];
}