import 'package:flutter/material.dart';
import '../../models/petroglifo.dart';
import '../../models/sitio.dart';
import '../../services/mock_data.dart';

class PetroglifoForm extends StatefulWidget {
  final Petroglifo? petroglifoToEdit; // null si es nuevo

  const PetroglifoForm({super.key, this.petroglifoToEdit});

  @override
  State<PetroglifoForm> createState() => _PetroglifoFormState();
}

class _PetroglifoFormState extends State<PetroglifoForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _codigoController;
  late TextEditingController _dimensionesController;
  late TextEditingController _descripcionController;

  Sitio? _sitioSeleccionado;
  String _tipoRoca = 'Granito';
  String _tecnicaGrabado = 'Percusión directa';
  TipoMotivo _tipoMotivo = TipoMotivo.zoomorfo;
  EstadoConservacion _estado = EstadoConservacion.regular;
  Visibilidad _visibilidad = Visibilidad.basica;

  final List<String> _tiposRoca = ['Granito', 'Pizarra', 'Arenisca', 'Otro'];
  final List<String> _tecnicas = [
    'Percusión directa',
    'Percusión indirecta',
    'Abrasión',
    'Mixto'
  ];

  @override
  void initState() {
    super.initState();
    final petro = widget.petroglifoToEdit;

    _codigoController = TextEditingController(text: petro?.codigo ?? '');
    _dimensionesController = TextEditingController(text: petro?.dimensiones ?? '');
    _descripcionController = TextEditingController(text: petro?.descripcion ?? '');

    if (petro != null) {
      _sitioSeleccionado = mockSitios.firstWhere((s) => s.id == petro.sitioId);
      _tipoRoca = petro.tipoRoca;
      _tecnicaGrabado = petro.tecnicaGrabado;
      _tipoMotivo = petro.tipoMotivo;
      _estado = petro.estado;
      _visibilidad = petro.visibilidad;
    } else {
      _sitioSeleccionado = mockSitios.isNotEmpty ? mockSitios.first : null;
    }
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _dimensionesController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_formKey.currentState!.validate() && _sitioSeleccionado != null) {
      final nuevoPetroglifo = Petroglifo(
        id: widget.petroglifoToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        codigo: _codigoController.text.trim(),
        sitioId: _sitioSeleccionado!.id,
        tipoRoca: _tipoRoca,
        dimensiones: _dimensionesController.text.trim(),
        tecnicaGrabado: _tecnicaGrabado,
        tipoMotivo: _tipoMotivo,
        descripcion: _descripcionController.text.trim(),
        estado: _estado,
        visibilidad: _visibilidad,
        imagenPrincipal: widget.petroglifoToEdit?.imagenPrincipal,
      );

      // Por ahora solo mostramos (en versión futura se guardaría en Hive o backend)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.petroglifoToEdit == null
              ? 'Petroglifo "${nuevoPetroglifo.codigo}" guardado correctamente'
              : 'Petroglifo actualizado correctamente'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, nuevoPetroglifo); // Retorna el objeto guardado
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.petroglifoToEdit == null
            ? 'Nuevo Petroglifo'
            : 'Editar Petroglifo'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Código
              TextFormField(
                controller: _codigoController,
                decoration: const InputDecoration(
                  labelText: 'Código de Pieza *',
                  hintText: 'Ej: MAU-001-P03',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'El código es obligatorio' : null,
              ),
              const SizedBox(height: 16),

              // Sitio
              DropdownButtonFormField<Sitio>(
                value: _sitioSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Sitio',
                  border: OutlineInputBorder(),
                ),
                items: mockSitios.map((sitio) {
                  return DropdownMenuItem(
                    value: sitio,
                    child: Text('${sitio.codigo} - ${sitio.nombre}'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _sitioSeleccionado = value),
                validator: (value) => value == null ? 'Debe seleccionar un sitio' : null,
              ),
              const SizedBox(height: 16),

              // Tipo de Roca
              DropdownButtonFormField<String>(
                value: _tipoRoca,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Roca',
                  border: OutlineInputBorder(),
                ),
                items: _tiposRoca.map((tipo) => DropdownMenuItem(value: tipo, child: Text(tipo))).toList(),
                onChanged: (value) => setState(() => _tipoRoca = value!),
              ),
              const SizedBox(height: 16),

              // Dimensiones
              TextFormField(
                controller: _dimensionesController,
                decoration: const InputDecoration(
                  labelText: 'Dimensiones (alto × ancho)',
                  hintText: 'Ej: 120 × 80 cm',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Técnica de Grabado
              DropdownButtonFormField<String>(
                value: _tecnicaGrabado,
                decoration: const InputDecoration(
                  labelText: 'Técnica de Grabado',
                  border: OutlineInputBorder(),
                ),
                items: _tecnicas.map((tec) => DropdownMenuItem(value: tec, child: Text(tec))).toList(),
                onChanged: (value) => setState(() => _tecnicaGrabado = value!),
              ),
              const SizedBox(height: 16),

              // Tipo de Motivo
              DropdownButtonFormField<TipoMotivo>(
                value: _tipoMotivo,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Motivo',
                  border: OutlineInputBorder(),
                ),
                items: TipoMotivo.values.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _tipoMotivo = value!),
              ),
              const SizedBox(height: 16),

              // Estado de Conservación
              DropdownButtonFormField<EstadoConservacion>(
                value: _estado,
                decoration: const InputDecoration(
                  labelText: 'Estado de Conservación',
                  border: OutlineInputBorder(),
                ),
                items: EstadoConservacion.values.map((estado) {
                  return DropdownMenuItem(
                    value: estado,
                    child: Text(estado.name.toUpperCase().replaceAllMapped(
                          RegExp(r'([A-Z])'),
                          (m) => ' ${m[0]}',
                        ).trim()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _estado = value!),
              ),
              const SizedBox(height: 16),

              // Visibilidad
              DropdownButtonFormField<Visibilidad>(
                value: _visibilidad,
                decoration: const InputDecoration(
                  labelText: 'Visibilidad Pública',
                  border: OutlineInputBorder(),
                ),
                items: Visibilidad.values.map((v) {
                  return DropdownMenuItem(
                    value: v,
                    child: Text(v.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _visibilidad = value!),
              ),
              const SizedBox(height: 16),

              // Descripción
              TextFormField(
                controller: _descripcionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _guardar,
                  child: Text(
                    widget.petroglifoToEdit == null ? 'Guardar Nuevo Petroglifo' : 'Actualizar Petroglifo',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}