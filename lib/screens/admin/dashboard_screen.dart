// dashboard_screen.dart
// dashboard_screen.dart
import 'package:flutter/material.dart';
import 'petroglifo_form.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Administrativo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Nuevo Petroglifo'),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PetroglifoForm()),
                );
                if (result != null) {
                  // Aquí puedes actualizar mockData o Hive
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Petroglifo guardado')),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            const Text('Más opciones próximamente...'),
          ],
        ),
      ),
    );
  }
}