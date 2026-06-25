import 'package:flutter/material.dart';
import 'petroglifo_form.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Gestión'),
        backgroundColor: const Color(0xFF1A3A17),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Estadísticas
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: const [
                  _StatCard('23', 'Sitios'),
                  _StatCard('147', 'Petroglifos'),
                  _StatCard('4', 'Usuarios'),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Text(
                'Módulos Principales',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            _menuItem(
              context,
              Icons.map,
              'Gestión de Sitios',
              'Registrar y editar sitios arqueológicos',
              Colors.green,
            ),

            _menuItem(
              context,
              Icons.article,
              'Fichas de Petroglifos',
              'Crear y actualizar fichas técnicas',
              Colors.amber,
            ),

            _menuItem(
              context,
              Icons.upload_file,
              'Archivos Multimedia',
              'Subir fotos, calcos y PDFs',
              Colors.blue,
            ),

            _menuItem(
              context,
              Icons.people,
              'Gestión de Usuarios',
              'Administrar colaboradores',
              Colors.purple,
            ),

            _menuItem(
              context,
              Icons.calendar_today,
              'Registro de Visitas',
              'Historial de campo',
              Colors.orange,
            ),

            _menuItem(
              context,
              Icons.bar_chart,
              'Reportes',
              'Estadísticas del sistema',
              Colors.teal,
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A8F42),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PetroglifoForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (title.contains('Petroglifos')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PetroglifoForm(),
              ),
            );
          }
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;

  const _StatCard(this.number, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Column(
            children: [
              Text(
                number,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D5A27),
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}