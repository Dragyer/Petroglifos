import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/petroglifo.dart';

class PetroglifoCard extends StatelessWidget {
  final Petroglifo petro;

  const PetroglifoCard({super.key, required this.petro});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        leading: petro.imagenPrincipal != null
            ? Image.asset(petro.imagenPrincipal!, width: 60, height: 60, fit: BoxFit.cover)
            : const Icon(Icons.image, size: 60, color: Colors.grey),
        title: Text(petro.codigo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${petro.tipoMotivo.name.toUpperCase()} • ${petro.estadoTexto}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => context.push('/detail/${petro.id}'),
      ),
    );
  }
}