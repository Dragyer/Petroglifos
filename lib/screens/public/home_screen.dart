import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/database_service.dart';

class PublicHomeScreen extends StatefulWidget {
  const PublicHomeScreen({super.key});

  @override
  State<PublicHomeScreen> createState() => _PublicHomeScreenState();
}

class _PublicHomeScreenState extends State<PublicHomeScreen> {
  int totalSitios = 0;
  int totalPetros = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final db = DatabaseService.instance;
    setState(() {
      totalSitios = db.getAllSitios().length;
      totalPetros = db.getAllPetroglifos().length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF2D5A27), Color(0xFF4A8F42)]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Petroglifos Maule', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Patrimonio arqueológico del Maule', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _statCard(totalSitios.toString(), 'Sitios'),
                _statCard(totalPetros.toString(), 'Petroglifos'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Últimos registros', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: DatabaseService.instance.getAllPetroglifos().length,
              itemBuilder: (context, i) {
                final p = DatabaseService.instance.getAllPetroglifos()[i];
                return ListTile(
                  leading: const Text('🪨', style: TextStyle(fontSize: 32)),
                  title: Text(p.codigo),
                  subtitle: Text(p.tipoMotivo.name),
                  onTap: () => context.push('/detail/${p.id}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String num, String label) => Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(num, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                Text(label),
              ],
            ),
          ),
        ),
      );
}