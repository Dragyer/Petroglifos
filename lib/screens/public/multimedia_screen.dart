import 'package:flutter/material.dart';
import '../../models/petroglifo.dart';
import '../../services/database_service.dart';

class MultimediaScreen extends StatefulWidget {
  final Petroglifo petroglifo;

  const MultimediaScreen({super.key, required this.petroglifo});

  @override
  State<MultimediaScreen> createState() => _MultimediaScreenState();
}

class _MultimediaScreenState extends State<MultimediaScreen> {
  late Petroglifo _petro;

  // En producción, estos serían rutas reales de archivos.
  // Para el prototipo usamos una lista en memoria.
  final List<_ArchivoMock> _archivos = [
    _ArchivoMock(nombre: 'foto_campo_1.jpg', tipo: 'imagen', esPublico: true,  descripcion: 'Vista frontal del grabado'),
    _ArchivoMock(nombre: 'foto_campo_2.jpg', tipo: 'imagen', esPublico: true,  descripcion: 'Detalle sector superior'),
    _ArchivoMock(nombre: 'foto_alta_res.jpg',tipo: 'imagen', esPublico: false, descripcion: 'Foto sin procesar - trabajo'),
    _ArchivoMock(nombre: 'calco_digital.pdf',tipo: 'pdf',    esPublico: true,  descripcion: 'Calco escala 1:1'),
  ];

  @override
  void initState() {
    super.initState();
    _petro = widget.petroglifo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multimedia · ${_petro.codigo}'),
        backgroundColor: const Color(0xFF1A3A17),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen principal
          if (_petro.imagenPrincipal != null || _archivos.any((a) => a.esPrincipal))
            _buildImagenPrincipalBanner(),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '${_archivos.length} archivos asociados',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _archivos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final archivo = _archivos[i];
                return Card(
                  child: ListTile(
                    leading: _archivoIcon(archivo),
                    title: Text(archivo.nombre,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                    subtitle: Text(archivo.descripcion,
                        style: const TextStyle(fontSize: 12)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Badge público/restringido
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: archivo.esPublico
                                ? const Color(0xFFE3F2E1)
                                : const Color(0xFFFDE8E8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            archivo.esPublico ? 'Público' : 'Restringido',
                            style: TextStyle(
                              fontSize: 10,
                              color: archivo.esPublico
                                  ? const Color(0xFF2D5A27)
                                  : const Color(0xFFB53030),
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (action) =>
                              _handleArchivo(action, i, archivo),
                          itemBuilder: (_) => [
                            if (!archivo.esPrincipal && archivo.tipo == 'imagen')
                              const PopupMenuItem(
                                  value: 'principal',
                                  child: Text('Definir como imagen principal')),
                            PopupMenuItem(
                                value: 'toggle',
                                child: Text(archivo.esPublico
                                    ? 'Marcar como restringido'
                                    : 'Marcar como público')),
                            const PopupMenuItem(
                                value: 'delete',
                                child: Text('Eliminar archivo',
                                    style: TextStyle(color: Colors.red))),
                          ],
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF2D5A27),
        onPressed: _simularSubida,
        icon: const Icon(Icons.upload_file),
        label: const Text('Subir archivo'),
      ),
    );
  }

  Widget _buildImagenPrincipalBanner() => Container(
        height: 120,
        width: double.infinity,
        color: const Color(0xFFE3F2E1),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Text('🪨', style: TextStyle(fontSize: 60)),
            Positioned(
              bottom: 8, right: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: const Color(0xFF2D5A27),
                    borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, size: 12, color: Colors.white),
                    SizedBox(width: 4),
                    Text('Imagen principal',
                        style: TextStyle(color: Colors.white, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _archivoIcon(_ArchivoMock archivo) => Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: archivo.tipo == 'pdf'
              ? const Color(0xFFFDE8E8)
              : const Color(0xFFD4EDD0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            archivo.tipo == 'pdf' ? '📄' : '📷',
            style: const TextStyle(fontSize: 20),
          ),
        ),
      );

  void _handleArchivo(String action, int index, _ArchivoMock archivo) async {
    switch (action) {
      case 'principal':
        final confirmar = await _confirmarDialog(
          '¿Establecer como imagen principal?',
          'Esta imagen aparecerá como portada del petroglifo en el catálogo público.',
        );
        if (confirmar) {
          setState(() {
            for (final a in _archivos) { a.esPrincipal = false; }
            archivo.esPrincipal = true;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ Imagen principal actualizada')),
            );
          }
        }
        break;
      case 'toggle':
        setState(() => archivo.esPublico = !archivo.esPublico);
        break;
      case 'delete':
        final confirmar = await _confirmarDialog(
          'Eliminar archivo',
          '¿Eliminar "${archivo.nombre}"? Esta acción no se puede deshacer.',
        );
        if (confirmar) {
          setState(() => _archivos.removeAt(index));
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Archivo eliminado')),
            );
          }
        }
        break;
    }
  }

  Future<bool> _confirmarDialog(String titulo, String contenido) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(titulo),
            content: Text(contenido),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar')),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Confirmar')),
            ],
          ),
        ) ??
        false;
  }

  void _simularSubida() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _SubidaSheet(
        onSubido: (archivo) {
          setState(() => _archivos.add(archivo));
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sheet de subida de archivo
// ─────────────────────────────────────────────

class _SubidaSheet extends StatefulWidget {
  final Function(_ArchivoMock) onSubido;

  const _SubidaSheet({required this.onSubido});

  @override
  State<_SubidaSheet> createState() => _SubidaSheetState();
}

class _SubidaSheetState extends State<_SubidaSheet> {
  final _descCtrl = TextEditingController();
  String _tipo = 'imagen';
  bool _esPublico = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Subir archivo multimedia',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Zona de carga (simulada)
          GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'En la app real se abrirá el selector de archivos')),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey.shade400, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade50,
              ),
              child: const Column(
                children: [
                  Icon(Icons.photo_camera, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Toca para seleccionar archivo',
                      style: TextStyle(color: Colors.grey)),
                  Text('JPG, PNG o PDF · máx. 50 MB',
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          TextFormField(
            controller: _descCtrl,
            decoration: const InputDecoration(
                labelText: 'Descripción / pie de foto'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _tipo,
            decoration: const InputDecoration(labelText: 'Tipo de archivo'),
            items: const [
              DropdownMenuItem(value: 'imagen', child: Text('Fotografía')),
              DropdownMenuItem(value: 'pdf', child: Text('Documento PDF')),
            ],
            onChanged: (v) => setState(() => _tipo = v!),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Archivo público', style: TextStyle(fontSize: 14)),
            subtitle: const Text('Visible en el visor sin login',
                style: TextStyle(fontSize: 12)),
            value: _esPublico,
            onChanged: (v) => setState(() => _esPublico = v),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onSubido(_ArchivoMock(
                nombre: 'nuevo_archivo.${_tipo == 'pdf' ? 'pdf' : 'jpg'}',
                tipo: _tipo,
                esPublico: _esPublico,
                descripcion: _descCtrl.text.trim().isEmpty
                    ? 'Sin descripción'
                    : _descCtrl.text.trim(),
              ));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('✅ Archivo subido correctamente'),
                    backgroundColor: Colors.green),
              );
            },
            child: const Text('Confirmar y subir archivo'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// Modelo local para el prototipo (sin Hive)
class _ArchivoMock {
  String nombre;
  String tipo;
  bool esPublico;
  String descripcion;
  bool esPrincipal;

  _ArchivoMock({
    required this.nombre,
    required this.tipo,
    required this.esPublico,
    required this.descripcion,
    this.esPrincipal = false,
  });
}
