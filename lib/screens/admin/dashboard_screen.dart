import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'petroglifo_form.dart';
import 'sitios_screen.dart';
import 'usuarios_screen.dart';
import '../../services/database_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService.instance;
    final totalSitios   = db.getAllSitios().length;
    final totalPetros   = db.getAllPetroglifos().length;
    final totalUsuarios = db.getAllUsuarios().length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Gestión'),
        backgroundColor: const Color(0xFF1A3A17),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              color: const Color(0xFF1A3A17),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bienvenido, Felipe',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  Text('Administrador del sistema',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),

            // Estadísticas
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  _StatCard(totalSitios.toString(), 'Sitios'),
                  _StatCard(totalPetros.toString(), 'Petroglifos'),
                  _StatCard(totalUsuarios.toString(), 'Usuarios'),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text('Módulos principales',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      letterSpacing: 0.3)),
            ),

            _menuItem(
              context,
              icon: Icons.map_outlined,
              title: 'Gestión de Sitios',
              subtitle: 'Registrar, editar y desactivar sitios arqueológicos',
              color: Colors.green,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SitiosScreen())),
            ),
            _menuItem(
              context,
              icon: Icons.article_outlined,
              title: 'Fichas de Petroglifos',
              subtitle: 'Crear y actualizar fichas técnicas',
              color: Colors.amber,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PetroglifoForm())),
            ),
            _menuItem(
              context,
              icon: Icons.upload_file,
              title: 'Archivos Multimedia',
              subtitle: 'Subir fotos, calcos y documentos PDF',
              color: Colors.blue,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Selecciona un petroglifo para gestionar su multimedia')),
              ),
            ),
            _menuItem(
              context,
              icon: Icons.people_outline,
              title: 'Gestión de Usuarios',
              subtitle: 'Administrar investigadores y permisos',
              color: Colors.purple,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const UsuariosScreen())),
            ),
            _menuItem(
              context,
              icon: Icons.calendar_today_outlined,
              title: 'Registro de Visitas',
              subtitle: 'Historial de visitas de campo',
              color: Colors.orange,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SitiosScreen())),
            ),
            _menuItem(
              context,
              icon: Icons.bar_chart,
              title: 'Reportes',
              subtitle: 'Estadísticas y métricas del sistema',
              color: Colors.teal,
              onTap: () => _mostrarReportesDialog(context),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF4A8F42),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PetroglifoForm()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nueva ficha'),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(icon, color: color),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle,
            style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _mostrarReportesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Generar reporte'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.map, color: Colors.green),
              title: const Text('Reporte de sitios'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.article, color: Colors.amber),
              title: const Text('Reporte de petroglifos'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.orange),
              title: const Text('Historial de visitas'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar')),
        ],
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
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text(number,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D5A27))),
              Text(label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}