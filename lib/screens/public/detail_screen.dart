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
      body: CustomScrollView(
        slivers: [
          // Hero Section
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB8D8B5), Color(0xFF7FB878)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: Text('🪨', style: TextStyle(fontSize: 100)),
                ),
              ),
            ),
            title: Text(petro.codigo),
            backgroundColor: const Color(0xFF2D5A27),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título y Sitio
                  Text(
                    'Petroglifo Cerro Quiahue',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.map, size: 16, color: Color(0xFF2D5A27)),
                      const SizedBox(width: 6),
                      Text(
                        'Sitio Cerro Quiahue · Linares',
                        style: const TextStyle(color: Color(0xFF2D5A27)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Badges
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildBadge('Zoomorfo', const Color(0xFFB87A00)),
                      _buildBadge(petro.estadoTexto, const Color(0xFFB87A00)),
                      _buildBadge('Percusión directa', const Color(0xFF2D5A27)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Info Grid
                  const Text('Información Técnica', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    children: [
                      _infoCard('Tipo de roca', petro.tipoRoca),
                      _infoCard('Dimensiones', petro.dimensiones),
                      _infoCard('Técnica', petro.tecnicaGrabado),
                      _infoCard('Estado', petro.estadoTexto),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Descripción
                  const Text('Descripción', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    petro.descripcion,
                    style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                  ),

                  const SizedBox(height: 24),

                  // Galería
                  const Text('Galería Multimedia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _mediaThumb('📷'),
                        _mediaThumb('📷'),
                        _mediaThumb('📷'),
                        _mediaThumb('📄', isPdf: true),
                        _mediaThumb('🔒', isRestricted: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _infoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _mediaThumb(String emoji, {bool isPdf = false, bool isRestricted = false}) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: isPdf ? const Color(0xFFFDE8E8) : const Color(0xFFD4EDD0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          if (isRestricted)
            const Text('Restringido', style: TextStyle(fontSize: 9, color: Colors.red)),
        ],
      ),
    );
  }
}