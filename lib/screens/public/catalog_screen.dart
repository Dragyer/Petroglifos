import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/petroglifo.dart';
import '../../services/mock_data.dart';
import '../widgets/petroglifo_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String filtro = 'Todos';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = mockPetroglifos.where((p) {
      final matchesFiltro = filtro == 'Todos' || 
          p.tipoMotivo.name.toLowerCase() == filtro.toLowerCase();

      final matchesSearch = _searchController.text.isEmpty ||
          p.codigo.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          p.descripcion.toLowerCase().contains(_searchController.text.toLowerCase());

      return matchesFiltro && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        backgroundColor: const Color(0xFF2D5A27),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Buscar petroglifo, código o sitio...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // Filter Chips (horizontal scroll)
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                'Todos',
                'Zoomorfo',
                'Geometrico',
                'Antropomorfo',
                'Abstracto'
              ].map((filtroOption) {
                final isSelected = filtro == filtroOption;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filtroOption),
                    selected: isSelected,
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFF2D5A27),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      setState(() => filtro = selected ? filtroOption : 'Todos');
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Grid View (como en el HTML)
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No se encontraron resultados'))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.82,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final petro = filtered[index];
                      return GestureDetector(
                        onTap: () => context.push('/detail/${petro.id}'),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Imagen / Placeholder
                              Container(
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                ),
                                child: const Center(
                                  child: Text('🪨', style: TextStyle(fontSize: 48)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      petro.codigo,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      petro.tipoMotivo.name.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: _getBadgeColor(petro.tipoMotivo),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        petro.tipoMotivo.name,
                                        style: const TextStyle(fontSize: 10, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getBadgeColor(TipoMotivo tipo) {
    switch (tipo) {
      case TipoMotivo.zoomorfo:
        return const Color(0xFFB87A00);
      case TipoMotivo.geometrico:
        return const Color(0xFF2D5A27);
      case TipoMotivo.antropomorfo:
        return const Color(0xFFB53030);
      case TipoMotivo.abstracto:
        return const Color(0xFF5341A8);
      default:
        return Colors.grey;
    }
  }
}