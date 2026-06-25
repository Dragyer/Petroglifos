import 'package:flutter/material.dart';
import '../../services/mock_data.dart';
import '../../models/petroglifo.dart';

class DetailScreen extends StatelessWidget {
  final String petroId;

  const DetailScreen({super.key, required this.petroId});

  @override
  Widget build(BuildContext context) {
    final petro = mockPetroglifos.firstWhere((p) => p.id == petroId);

    return Scaffold(
      appBar: AppBar(title: Text(petro.codigo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (petro.imagenPrincipal != null)
              Image.asset(petro.imagenPrincipal!, height: 250, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text('Descripción', style: Theme.of(context).textTheme.titleLarge),
            Text(petro.descripcion),
            const SizedBox(height: 12),
            Text('Tipo: ${petro.tipoMotivo.name.toUpperCase()}'),
            Text('Estado: ${petro.estadoTexto}'),
            Text('Técnica: ${petro.tecnicaGrabado}'),
            Text('Dimensiones: ${petro.dimensiones}'),
            const SizedBox(height: 20),
            const Text('Imágenes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Aquí puedes agregar un GridView para más imágenes
          ],
        ),
      ),
    );
  }
}