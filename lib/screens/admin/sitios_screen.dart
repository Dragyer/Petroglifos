import 'package:flutter/material.dart';
import '../../models/visita.dart';
import '../../models/sitio.dart';
import '../../services/database_service.dart';

class SitiosScreen extends StatefulWidget {
  const SitiosScreen({super.key});

  @override
  State<SitiosScreen> createState() => _SitiosScreenState();
}

class _SitiosScreenState extends State<SitiosScreen> {
  List<Sitio> _sitios = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() => setState(() {
        _sitios = DatabaseService.instance.getAllSitios();
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Sitios'),
        backgroundColor: const Color(0xFF1A3A17),
      ),
      body: _sitios.isEmpty
          ? const Center(child: Text('No hay sitios registrados'))
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: _sitios.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final sitio = _sitios[i];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: sitio.estaActivo
                          ? const Color(0xFFE3F2E1)
                          : Colors.grey.shade200,
                      child: Icon(
                        Icons.map_outlined,
                        color: sitio.estaActivo
                            ? const Color(0xFF2D5A27)
                            : Colors.grey,
                      ),
                    ),
                    title: Text(sitio.nombre,
                        style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text('${sitio.codigo} · ${sitio.comuna}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!sitio.estaActivo)
                          const Chip(
                            label: Text('Inactivo',
                                style: TextStyle(fontSize: 10)),
                            padding: EdgeInsets.zero,
                          ),
                        if (sitio.esRestringido)
                          const Icon(Icons.lock_outline,
                              size: 16, color: Colors.orange),
                        PopupMenuButton<String>(
                          onSelected: (action) =>
                              _handleSitioAction(action, sitio),
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                                value: 'edit',
                                child: Text('Editar')),
                            const PopupMenuItem(
                                value: 'visita',
                                child: Text('Registrar visita')),
                            PopupMenuItem(
                                value: 'toggle',
                                child: Text(sitio.estaActivo
                                    ? 'Desactivar'
                                    : 'Activar')),
                          ],
                        ),
                      ],
                    ),
                    onTap: () => _mostrarDetalleSitio(sitio),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo sitio'),
        backgroundColor: const Color(0xFF2D5A27),
      ),
    );
  }

  void _handleSitioAction(String action, Sitio sitio) async {
    switch (action) {
      case 'edit':
        _abrirFormulario(sitio: sitio);
        break;
      case 'toggle':
        sitio.estaActivo = !sitio.estaActivo;
        await DatabaseService.instance.saveSitio(sitio);
        _refresh();
        break;
      case 'visita':
        _registrarVisita(sitio);
        break;
    }
  }

  void _mostrarDetalleSitio(Sitio sitio) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sitio.nombre,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Código: ${sitio.codigo}',
                style: const TextStyle(color: Colors.grey)),
            Text('Comuna: ${sitio.comuna}'),
            Text('Coordenadas: ${sitio.coordenadasPublicas}'),
            const SizedBox(height: 8),
            Text(sitio.descripcion),
            const SizedBox(height: 16),
            Row(
              children: [
                _badgeWidget(
                    sitio.esRestringido ? 'Restringido' : 'Público',
                    sitio.esRestringido ? Colors.orange : Colors.green),
                const SizedBox(width: 8),
                _badgeWidget(
                    sitio.estaActivo ? 'Activo' : 'Inactivo',
                    sitio.estaActivo ? Colors.green : Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _badgeWidget(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: TextStyle(color: color, fontSize: 12)),
      );

  void _abrirFormulario({Sitio? sitio}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _SitioFormSheet(
        sitio: sitio,
        onSaved: _refresh,
      ),
    );
  }

  void _registrarVisita(Sitio sitio) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => _VisitaFormSheet(sitio: sitio, onSaved: _refresh),
    );
  }
}

// ─────────────────────────────────────────────
// Formulario de Sitio en BottomSheet
// ─────────────────────────────────────────────

class _SitioFormSheet extends StatefulWidget {
  final Sitio? sitio;
  final VoidCallback onSaved;

  const _SitioFormSheet({this.sitio, required this.onSaved});

  @override
  State<_SitioFormSheet> createState() => _SitioFormSheetState();
}

class _SitioFormSheetState extends State<_SitioFormSheet> {
  final _formKey     = GlobalKey<FormState>();
  final _nombreCtrl  = TextEditingController();
  final _codigoCtrl  = TextEditingController();
  final _comunaCtrl  = TextEditingController();
  final _descCtrl    = TextEditingController();
  final _latCtrl     = TextEditingController();
  final _lngCtrl     = TextEditingController();
  bool _esRestringido = false;

  @override
  void initState() {
    super.initState();
    if (widget.sitio != null) {
      final s = widget.sitio!;
      _nombreCtrl.text = s.nombre;
      _codigoCtrl.text = s.codigo;
      _comunaCtrl.text = s.comuna;
      _descCtrl.text   = s.descripcion;
      _latCtrl.text    = s.lat.toString();
      _lngCtrl.text    = s.lng.toString();
      _esRestringido   = s.esRestringido;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.sitio == null ? 'Registrar sitio' : 'Editar sitio',
                style: const TextStyle(
                    fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _field('Nombre *', _nombreCtrl),
              _field('Código interno *', _codigoCtrl,
                  hint: 'MAU-001'),
              _field('Comuna *', _comunaCtrl),
              _field('Descripción del entorno', _descCtrl,
                  maxLines: 2, required: false),
              Row(children: [
                Expanded(child: _field('Latitud *', _latCtrl,
                    hint: '-35.85', keyboardType: TextInputType.number)),
                const SizedBox(width: 10),
                Expanded(child: _field('Longitud *', _lngCtrl,
                    hint: '-71.55', keyboardType: TextInputType.number)),
              ]),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Sitio restringido',
                    style: TextStyle(fontSize: 14)),
                subtitle: const Text(
                    'Oculta coordenadas exactas en el visor público',
                    style: TextStyle(fontSize: 12)),
                value: _esRestringido,
                onChanged: (v) => setState(() => _esRestringido = v),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _guardar,
                child: Text(widget.sitio == null ? 'Registrar sitio' : 'Guardar cambios'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    String? hint,
    int maxLines = 1,
    bool required = true,
    TextInputType? keyboardType,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(labelText: label, hintText: hint),
          validator: required
              ? (v) => (v?.trim().isEmpty ?? true) ? 'Requerido' : null
              : null,
        ),
      );

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final sitio = widget.sitio ??
        Sitio(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nombre: '',
          codigo: '',
          comuna: '',
          descripcion: '',
          lat: 0,
          lng: 0,
        );

    sitio.nombre       = _nombreCtrl.text.trim();
    sitio.codigo       = _codigoCtrl.text.trim();
    sitio.comuna       = _comunaCtrl.text.trim();
    sitio.descripcion  = _descCtrl.text.trim();
    sitio.lat          = double.tryParse(_latCtrl.text) ?? 0;
    sitio.lng          = double.tryParse(_lngCtrl.text) ?? 0;
    sitio.esRestringido = _esRestringido;

    await DatabaseService.instance.saveSitio(sitio);
    widget.onSaved();

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Sitio guardado correctamente')),
      );
    }
  }
}

// ─────────────────────────────────────────────
// Formulario de Visita (CU-04)
// ─────────────────────────────────────────────

class _VisitaFormSheet extends StatefulWidget {
  final Sitio sitio;
  final VoidCallback onSaved;

  const _VisitaFormSheet({required this.sitio, required this.onSaved});

  @override
  State<_VisitaFormSheet> createState() => _VisitaFormSheetState();
}

class _VisitaFormSheetState extends State<_VisitaFormSheet> {
  final _obsCtrl = TextEditingController();
  DateTime _fecha = DateTime.now();

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
          Text('Registrar visita a ${widget.sitio.nombre}',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today,
                color: Color(0xFF2D5A27)),
            title: Text(
                '${_fecha.day}/${_fecha.month}/${_fecha.year}'),
            subtitle: const Text('Fecha de visita'),
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: _fecha,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (d != null) setState(() => _fecha = d);
            },
          ),
          TextFormField(
            controller: _obsCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Observaciones',
              hintText: 'Condiciones del sitio, hallazgos, acceso...',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _guardar,
            child: const Text('Registrar visita'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _guardar() async {
    final visita = Visita(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sitioId: widget.sitio.id,
      investigadorId: 'u1',
      fecha: _fecha,
      observaciones: _obsCtrl.text.trim(),
    );
    await DatabaseService.instance.saveVisita(visita);
    widget.onSaved();
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Visita registrada')),
      );
    }
  }
}


