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
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  final _dimensionesController = TextEditingController();
  final _descripcionController = TextEditingController();

  Sitio? _sitioSeleccionado;
  TipoMotivo _tipoMotivo = TipoMotivo.zoomorfo;
  EstadoConservacion _estado = EstadoConservacion.regular;
  Visibilidad _visibilidad = Visibilidad.basica;
  String _tipoRoca = 'Granito';
  String _tecnicaGrabado = 'Percusión directa';

  @override
  void initState() {
    super.initState();
    if (widget.petroglifoToEdit != null) {
      final p = widget.petroglifoToEdit!;
      _codigoController.text = p.codigo;
      _dimensionesController.text = p.dimensiones;
      _descripcionController.text = p.descripcion;
      _tipoMotivo = p.tipoMotivo;
      _estado = p.estado;
      _visibilidad = p.visibilidad;
      _tipoRoca = p.tipoRoca;
      _tecnicaGrabado = p.tecnicaGrabado;
    }
    _sitioSeleccionado = mockSitios.first;
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.petroglifoToEdit == null ? 'Nueva Ficha Técnica' : 'Editar Ficha'),
        backgroundColor: const Color(0xFF1A3A17),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Código de pieza *', _codigoController, hint: 'MAU-003-P05'),
              _buildDropdownSitio(),
              _buildDropdown('Tipo de motivo *', TipoMotivo.values, _tipoMotivo, (v) => setState(() => _tipoMotivo = v!)),
              _buildTextField('Dimensiones', _dimensionesController, hint: '45 × 38 cm'),
              _buildDropdown('Técnica de grabado', ['Percusión directa', 'Percusión indirecta', 'Abrasión', 'Mixto'], _tecnicaGrabado, (v) => setState(() => _tecnicaGrabado = v!)),
              _buildDropdown('Tipo de roca', ['Granito', 'Pizarra', 'Arenisca', 'Otro'], _tipoRoca, (v) => setState(() => _tipoRoca = v!)),
              _buildDropdown('Estado de conservación *', EstadoConservacion.values, _estado, (v) => setState(() => _estado = v!)),
              _buildDropdown('Visibilidad pública', Visibilidad.values, _visibilidad, (v) => setState(() => _visibilidad = v!)),
              
              const SizedBox(height: 12),
              const Text('Descripción del motivo', style: TextStyle(fontWeight: FontWeight.w500)),
              TextFormField(
                controller: _descripcionController,
                maxLines: 4,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),

              // Upload Zone
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.photo_camera, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Subir imagen principal (JPG/PNG, máx. 50 MB)', textAlign: TextAlign.center),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ Ficha guardada correctamente')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D5A27)),
                  child: const Text('Guardar Ficha Técnica', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    
  }

  Widget _buildTextField(String label, TextEditingController controller, {String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
            ),
            validator: (value) => value?.trim().isEmpty ?? true ? 'Este campo es obligatorio' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>(String label, List<T> items, T value, Function(T?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          DropdownButtonFormField<T>(
            value: value,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item.toString().split('.').last),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSitio() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sitio arqueológico *', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          DropdownButtonFormField<Sitio>(
            value: _sitioSeleccionado,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            items: mockSitios.map((s) => DropdownMenuItem(value: s, child: Text('${s.codigo} - ${s.nombre}'))).toList(),
            onChanged: (val) => setState(() => _sitioSeleccionado = val),
          ),
        ],
      ),
    );
  }
  
  void _guardar() async {
  if (_formKey.currentState!.validate() && _sitioSeleccionado != null) {
    final nuevo = Petroglifo(
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
    );

    await DatabaseService.instance.savePetroglifo(nuevo);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Petroglifo guardado correctamente'), backgroundColor: Colors.green),
    );
    Navigator.pop(context, nuevo);
  }
}

}
