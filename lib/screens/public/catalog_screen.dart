import 'package:flutter/material.dart';
import '../../services/mock_data.dart';
import '../widgets/petroglifo_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String filtro = 'Todos';

  @override
  Widget build(BuildContext context) {
    final filtered = mockPetroglifos.where((p) {
      if (filtro == 'Todos') return true;
      return p.tipoMotivo.name == filtro.toLowerCase();
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Petroglifos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              value: filtro,
              items: ['Todos', 'Zoomorfo', 'Geometrico', 'Antropomorfo', 'Abstracto']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => filtro = val!),
              decoration: const InputDecoration(labelText: 'Filtrar por tipo'),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No se encontraron resultados'))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => PetroglifoCard(petro: filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }
}