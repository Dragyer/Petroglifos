import 'package:flutter/material.dart';
import '../../models/petroglifo.dart';
import '../../models/sitio.dart';
import '../../services/database_service.dart';
import '../../services/mock_data.dart';

class PetroglifoForm extends StatefulWidget {
  final Petroglifo? petroglifoToEdit;

  const PetroglifoForm({super.key, this.petroglifoToEdit});

  @override
  State<PetroglifoForm> createState() => _PetroglifoFormState();
}

class _PetroglifoFormState extends State<PetroglifoForm> {
  final _formKey            = GlobalKey<FormState>();
  final _codigoController   = TextEditingController();
  final _dimensionesController = TextEditingController();
  final _descripcionController = TextEditingController();

  Sitio?              _sitioSeleccionado;
  TipoMotivo          _tipoMotivo    = TipoMotivo.zoomorfo;
  EstadoConservacion  _estado        = EstadoConservacion.regular;
  Visibilidad         _visibilidad   = Visibilidad.basica;
  String              _tipoRoca      = 'Granito';
  String              _tecnicaGrabado = 'Percusión directa';

  List<Sitio> get _sitios => DatabaseService.instance.getAllSitios();

  @override
  void initState() {
    super.initState();
    final sitios = _sitios;
    _sitioSeleccionado = sitios.isNotEmpty ? sitios.first : null;

    if (widget.petroglifoToEdit != null) {
      final p = widget.petroglifoToEdit!;
      _codigoController.text      = p.codigo;
      _dimensionesController.text = p.dimensiones;
      _descripcionController.text = p.descripcion;
      _tipoMotivo     = p.tipoMotivo;
      _estado         = p.estado;
      _visibilidad    = p.visibilidad;
      _tipoRoca       = p.tipoRoca;
      _tecnicaGrabado = p.tecnicaGrabado;
      _sitioSeleccionado =
          sitios.firstWhere((s) => s.id == p.sitioId, orElse: () => sitios.first);
    }
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _dimensionesController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.petroglifoToEdit == null
            ? 'Nueva Ficha Técnica'
            : 'Editar Ficha'),
        backgroundColor: const Color(0xFF1A3A17),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                'Código de pieza *',
                _codigoController,
                hint: 'MAU-003-P05',
              ),
              _buildDropdownSitio(),
              _buildDropdown<TipoMotivo>(
                'Tipo de motivo iconográfico *',
                TipoMotivo.values,
                _tipoMotivo,
                (v) => setState(() => _tipoMotivo = v!),
                labelOf: (v) => _labelMotivo(v),
              ),
              _buildTextField(
                'Dimensiones (alto × ancho cm)',
                _dimensionesController,
                hint: '45 × 38',
              ),
              _buildDropdown<String>(
                'Técnica de grabado',
                ['Percusión directa', 'Percusión indirecta', 'Abrasión', 'Mixto'],
                _tecnicaGrabado,
                (v) => setState(() => _tecnicaGrabado = v!),
              ),
              _buildDropdown<String>(
                'Tipo de roca soporte',
                ['Granito', 'Pizarra', 'Arenisca', 'Otro'],
                _tipoRoca,
                (v) => setState(() => _tipoRoca = v!),
              ),
              _buildDropdown<EstadoConservacion>(
                'Estado de conservación *',
                EstadoConservacion.values,
                _estado,
                (v) => setState(() => _estado = v!),
                labelOf: (v) => _labelEstado(v),
              ),
              _buildDropdown<Visibilidad>(
                'Visibilidad pública',
                Visibilidad.values,
                _visibilidad,
                (v) => setState(() => _visibilidad = v!),
                labelOf: (v) => _labelVisibilidad(v),
              ),

              const SizedBox(height: 4),
              const Text('Descripción del motivo',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descripcionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Describe el motivo iconográfico...',
                ),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),

              // Zona de carga de imagen principal
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'En la app real se abrirá el selector de imagen')),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.shade400,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade50,
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.photo_camera, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Subir imagen principal',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey)),
                      Text('JPG/PNG · máx. 50 MB',
                          style:
                              TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _guardar,
                  child: Text(
                    widget.petroglifoToEdit == null
                        ? 'Guardar Ficha Técnica'
                        : 'Actualizar Ficha',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Helpers de formulario ────────────────────

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
    bool required = true,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: const OutlineInputBorder(),
              ),
              validator: required
                  ? (v) =>
                      (v?.trim().isEmpty ?? true) ? 'Campo obligatorio' : null
                  : null,
            ),
          ],
        ),
      );

  Widget _buildDropdown<T>(
    String label,
    List<T> items,
    T value,
    Function(T?) onChanged, {
    String Function(T)? labelOf,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            DropdownButtonFormField<T>(
              value: value,
              decoration:
                  const InputDecoration(border: OutlineInputBorder()),
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(labelOf != null
                            ? labelOf(item)
                            : item.toString().split('.').last),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ],
        ),
      );

  Widget _buildDropdownSitio() => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sitio arqueológico *',
                style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            DropdownButtonFormField<Sitio>(
              value: _sitioSeleccionado,
              decoration:
                  const InputDecoration(border: OutlineInputBorder()),
              items: _sitios
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text('${s.codigo} — ${s.nombre}'),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => _sitioSeleccionado = val),
              validator: (v) =>
                  v == null ? 'Selecciona un sitio' : null,
            ),
          ],
        ),
      );

  // ── Labels legibles ──────────────────────────

  String _labelMotivo(TipoMotivo m) {
    switch (m) {
      case TipoMotivo.geometrico:    return 'Geométrico';
      case TipoMotivo.zoomorfo:      return 'Zoomorfo';
      case TipoMotivo.antropomorfo:  return 'Antropomorfo';
      case TipoMotivo.abstracto:     return 'Abstracto';
      case TipoMotivo.noIdentificado: return 'No identificado';
    }
  }

  String _labelEstado(EstadoConservacion e) {
    switch (e) {
      case EstadoConservacion.muyBueno: return 'Muy bueno';
      case EstadoConservacion.bueno:    return 'Bueno';
      case EstadoConservacion.regular:  return 'Regular';
      case EstadoConservacion.malo:     return 'Malo';
      case EstadoConservacion.critico:  return 'Crítico';
    }
  }

  String _labelVisibilidad(Visibilidad v) {
    switch (v) {
      case Visibilidad.completa:   return 'Completa';
      case Visibilidad.basica:     return 'Solo datos básicos';
      case Visibilidad.noMostrar:  return 'No mostrar';
    }
  }

  // ── Guardado ─────────────────────────────────

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_sitioSeleccionado == null) return;

    final nuevo = Petroglifo(
      id: widget.petroglifoToEdit?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      codigo:         _codigoController.text.trim(),
      sitioId:        _sitioSeleccionado!.id,
      tipoRoca:       _tipoRoca,
      dimensiones:    _dimensionesController.text.trim(),
      tecnicaGrabado: _tecnicaGrabado,
      tipoMotivo:     _tipoMotivo,
      descripcion:    _descripcionController.text.trim(),
      estado:         _estado,
      visibilidad:    _visibilidad,
    );

    await DatabaseService.instance.savePetroglifo(nuevo);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Ficha guardada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, nuevo);
    }
  }
}
