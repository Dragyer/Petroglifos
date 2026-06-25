import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/database_service.dart';
import '../../models/petroglifo.dart';
import '../../theme.dart';
import '../widgets/petroglifo_card.dart';

class PublicHomeScreen extends StatefulWidget {
  const PublicHomeScreen({super.key});

  @override
  State<PublicHomeScreen> createState() => _PublicHomeScreenState();
}

class _PublicHomeScreenState extends State<PublicHomeScreen> {
  List<Petroglifo> recientes = [];

  @override
  void initState() {
    super.initState();
    _loadRecientes();
  }

  Future<void> _loadRecientes() async {
    final db = DatabaseService.instance;
    setState(() {
      recientes = db.getAllPetroglifos().take(4).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Hero Banner
          Container(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2D5A27), Color(0xFF4A8F42), Color(0xFF6AB55E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Petroglifos Maule', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white)),
                Text('Patrimonio arqueológico de la Región del Maule', 
                     style: TextStyle(fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: const [
                StatCard(number: "23", label: "Sitios"),
                StatCard(number: "147", label: "Petroglifos"),
                StatCard(number: "512", label: "Archivos"),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Últimos registros', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: recientes.length,
              itemBuilder: (context, index) => PetroglifoCard(petro: recientes[index]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context, 0),
    );
  }

  Widget _buildBottomNav(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: AppTheme.primaryGreen,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Catálogo'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Sitios'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
      onTap: (index) {
        if (index == 1) context.push('/catalog');
      },
    );
  }
}

class StatCard extends StatelessWidget {
  final String number;
  final String label;
  const StatCard({super.key, required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(number, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D5A27))),
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}