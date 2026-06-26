import 'package:flutter/material.dart';
import '../../models/petroglifo.dart';
import '../../services/mock_data.dart';

class DetailScreen extends StatelessWidget {
  final String petroId;

  const DetailScreen({super.key, required this.petroId});

  @override
  Widget build(BuildContext context) {
    final petro = mockPetroglifos.firstWhere((p) => p.id == petroId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 190,
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
                child: const Center(child: Text('🪨', style: TextStyle(fontSize: 90))),
              ),
            ),
            title: Text(petro.codigo),
            backgroundColor: const Color(0xFF2D5A27),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Petroglifo Cerro Quiahue', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Color(0xFF2D5A27)),
                      const SizedBox(width: 6),
                      const Text('Sitio Cerro Quiahue · Linares', style: TextStyle(color: Color(0xFF2D5A27))),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Wrap(spacing: 8, children: [
                    _badge('Zoomorfo', const Color(0xFFB87A00)),
                    _badge(petro.estadoTexto, const Color(0xFFB87A00)),
                    _badge('Percusión directa', const Color(0xFF2D5A27)),
                  ]),

                  const SizedBox(height: 24),
                  const Text('Información Técnica', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _infoCard('Tipo de roca', petro.tipoRoca),
                      _infoCard('Dimensiones', petro.dimensiones),
                      _infoCard('Técnica', petro.tecnicaGrabado),
                      _infoCard('Estado', petro.estadoTexto),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Text('Descripción', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(petro.descripcion, style: const TextStyle(height: 1.6, fontSize: 14.5)),

                  const SizedBox(height: 24),
                  const Text('Galería Multimedia', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 88,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _mediaItem('📷'),
                        _mediaItem('📷'),
                        _mediaItem('📷'),
                        _mediaItem('📄', isPdf: true),
                        _mediaItem('🔒', isRestricted: true),
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

  Widget _badge(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12.5)),
      );

  Widget _infoCard(String label, String value) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      );

  Widget _mediaItem(String emoji, {bool isPdf = false, bool isRestricted = false}) => Container(
        width: 72,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isPdf ? const Color(0xFFFDE8E8) : const Color(0xFFD4EDD0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            if (isRestricted) const Text('Restringido', style: TextStyle(fontSize: 9, color: Colors.red)),
          ],
        ),
      );
}