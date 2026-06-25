import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/database_service.dart';
import '../../models/petroglifo.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String filtro = 'Todos';
  final TextEditingController _searchController = TextEditingController();
  List<Petroglifo> allPetros = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = DatabaseService.instance;
    setState(() {
      allPetros = db.getAllPetroglifos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = allPetros.where((p) {
      final matchesFiltro = filtro == 'Todos' || 
          p.tipoMotivo.name.toLowerCase() == filtro.toLowerCase();

      final matchesSearch = _searchController.text.isEmpty ||
          p.codigo.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          p.descripcion.toLowerCase().contains(_searchController.text.toLowerCase());

      return matchesFiltro && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo'), backgroundColor: const Color(0xFF2D5A27)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: 'Buscar petroglifo...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: ['Todos', 'Zoomorfo', 'Geometrico', 'Antropomorfo', 'Abstracto']
                  .map((f) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(f),
                          selected: filtro == f,
                          onSelected: (sel) => setState(() => filtro = sel ? f : 'Todos'),
                        ),
                      ))
                  .toList(),
            ),
          ),

          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No hay resultados'))
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
                          child: Column(
                            children: [
                              Container(
                                height: 110,
                                color: Colors.green.shade100,
                                child: const Center(child: Text('🪨', style: TextStyle(fontSize: 48))),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(petro.codigo, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(petro.tipoMotivo.name.toUpperCase()),
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
}