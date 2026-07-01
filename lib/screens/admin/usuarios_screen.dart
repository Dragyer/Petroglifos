import 'package:flutter/material.dart';
import '../../models/usuario.dart';
import '../../services/database_service.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  List<Usuario> _usuarios = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() => setState(() {
        _usuarios = DatabaseService.instance.getAllUsuarios();
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: const Color(0xFF1A3A17),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _usuarios.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final u = _usuarios[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: u.esAdmin
                    ? const Color(0xFFE3EEF8)
                    : const Color(0xFFE3F2E1),
                child: Text(
                  u.nombre.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: u.esAdmin
                        ? const Color(0xFF1A5A8F)
                        : const Color(0xFF2D5A27),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(u.nombre,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('${u.email}\n${u.run}'),
              isThreeLine: true,
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _rolBadge(u.rol),
                  const SizedBox(height: 4),
                  if (!u.estaActivo)
                    const Text('Inactivo',
                        style: TextStyle(fontSize: 10, color: Colors.red)),
                ],
              ),
              onLongPress: () => _toggleActivo(u),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF2D5A27),
        onPressed: _agregarUsuario,
        icon: const Icon(Icons.person_add),
        label: const Text('Registrar investigador'),
      ),
    );
  }

  Widget _rolBadge(RolUsuario rol) {
    final esAdmin = rol == RolUsuario.administrador;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: esAdmin
            ? const Color(0xFFE3EEF8)
            : const Color(0xFFE3F2E1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        esAdmin ? 'Admin' : 'Investigador',
        style: TextStyle(
          fontSize: 10,
          color: esAdmin
              ? const Color(0xFF1A5A8F)
              : const Color(0xFF2D5A27),
        ),
      ),
    );
  }

  Future<void> _toggleActivo(Usuario u) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(u.estaActivo ? 'Desactivar cuenta' : 'Activar cuenta'),
        content: Text(
            u.estaActivo
                ? '¿Desactivar la cuenta de ${u.nombre}?'
                : '¿Activar la cuenta de ${u.nombre}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirmar')),
        ],
      ),
    );
    if (confirmar == true) {
      u.estaActivo = !u.estaActivo;
      await DatabaseService.instance.saveUsuario(u);
      _refresh();
    }
  }

  void _agregarUsuario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _UsuarioFormSheet(onSaved: _refresh),
    );
  }
}

// ─────────────────────────────────────────────
// Formulario de nuevo investigador
// ─────────────────────────────────────────────

class _UsuarioFormSheet extends StatefulWidget {
  final VoidCallback onSaved;

  const _UsuarioFormSheet({required this.onSaved});

  @override
  State<_UsuarioFormSheet> createState() => _UsuarioFormSheetState();
}

class _UsuarioFormSheetState extends State<_UsuarioFormSheet> {
  final _formKey      = GlobalKey<FormState>();
  final _nombreCtrl   = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _runCtrl      = TextEditingController();
  RolUsuario _rol = RolUsuario.investigador;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Registrar investigador',
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nombreCtrl,
              decoration:
                  const InputDecoration(labelText: 'Nombre completo *'),
              validator: (v) =>
                  v?.trim().isEmpty ?? true ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _runCtrl,
              decoration:
                  const InputDecoration(labelText: 'RUN *', hintText: '12.345.678-9'),
              validator: (v) =>
                  v?.trim().isEmpty ?? true ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(labelText: 'Correo institucional *'),
              validator: (v) {
                if (v?.trim().isEmpty ?? true) return 'Requerido';
                if (!v!.contains('@')) return 'Correo inválido';
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RolUsuario>(
              value: _rol,
              decoration:
                  const InputDecoration(labelText: 'Rol en el sistema'),
              items: RolUsuario.values
                  .map((r) => DropdownMenuItem(
                        value: r,
                        child: Text(r == RolUsuario.administrador
                            ? 'Administrador'
                            : 'Investigador'),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _rol = v!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardar,
              child: const Text('Crear cuenta'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final usuario = Usuario(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: _nombreCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      run: _runCtrl.text.trim(),
      rol: _rol,
    );

    await DatabaseService.instance.saveUsuario(usuario);
    widget.onSaved();

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Investigador registrado. Se enviará correo con credenciales.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
