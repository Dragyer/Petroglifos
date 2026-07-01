import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/petroglifo.dart';
import '../../services/database_service.dart';

class PetroglifoCard extends StatelessWidget {
  final Petroglifo petro;

  const PetroglifoCard({super.key, required this.petro});

  @override
  Widget build(BuildContext context) {
    final sitio = DatabaseService.instance.getSitioById(petro.sitioId);
    final color = _color(petro.tipoMotivo);

    return GestureDetector(
      onTap: () => context.push('/detail/${petro.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 96,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Center(
                child: Icon(_icon(petro.tipoMotivo),
                    size: 44, color: color.withOpacity(0.75)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(petro.codigo,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12)),
                  if (sitio != null)
                    Text('${sitio.nombre} · ${sitio.comuna}',
                        style: TextStyle(
                            fontSize: 10, color: Colors.grey.shade600),
                        overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(petro.tipoMotivoTexto,
                        style: TextStyle(
                            fontSize: 10,
                            color: color,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _icon(TipoMotivo t) {
    switch (t) {
      case TipoMotivo.zoomorfo:       return Icons.pets;
      case TipoMotivo.geometrico:     return Icons.change_history;
      case TipoMotivo.antropomorfo:   return Icons.accessibility_new;
      case TipoMotivo.abstracto:      return Icons.auto_awesome;
      case TipoMotivo.noIdentificado: return Icons.help_outline;
    }
  }

  Color _color(TipoMotivo t) {
    switch (t) {
      case TipoMotivo.zoomorfo:       return const Color(0xFFB87A00);
      case TipoMotivo.geometrico:     return const Color(0xFF2D5A27);
      case TipoMotivo.antropomorfo:   return const Color(0xFFB53030);
      case TipoMotivo.abstracto:      return const Color(0xFF5341A8);
      case TipoMotivo.noIdentificado: return Colors.grey;
    }
  }
}