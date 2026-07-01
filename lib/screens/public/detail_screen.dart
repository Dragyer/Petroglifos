import 'package:flutter/material.dart';
import '../../models/petroglifo.dart';
import '../../services/database_service.dart';
import 'multimedia_screen.dart';

class DetailScreen extends StatelessWidget {
  final String petroId;

  const DetailScreen({super.key, required this.petroId});

  @override
  Widget build(BuildContext context) {
    final petro = DatabaseService.instance.getPetroglifoById(petroId);
    if (petro == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('No encontrado')),
        body: const Center(
          child: Text('El petroglifo no fue encontrado'),
        ),
      );
    }

    final sitio = DatabaseService.instance.getSitioById(petro.sitioId);
    final colorMotivo = _colorMotivo(petro.tipoMotivo);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      body: CustomScrollView(
        slivers: [
          // ── Hero con SliverAppBar ─────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF2D5A27),
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorMotivo.withOpacity(0.6),
                      colorMotivo.withOpacity(0.3),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    Icon(
                      _iconMotivo(petro.tipoMotivo),
                      size: 80,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(height: 8),
                    // Badges superpuestos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _HeroBadge(petro.tipoMotivoTexto),
                        const SizedBox(width: 6),
                        _HeroBadge(
                          petro.visibilidad == Visibilidad.completa
                              ? 'Público completo'
                              : 'Datos básicos',
                          icon: Icons.visibility,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            title: Text(petro.codigo,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {},
              ),
            ],
          ),

          // ── Contenido ────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título y sitio
                  Text(
                    sitio?.nombre ?? 'Sitio desconocido',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.place_outlined,
                          size: 16, color: colorMotivo),
                      const SizedBox(width: 4),
                      Text(
                        sitio != null
                            ? '${sitio.nombre} · ${sitio.comuna}'
                            : petro.sitioId,
                        style: TextStyle(
                            color: colorMotivo,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Badges de estado
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _Badge(
                        text: petro.tipoMotivoTexto,
                        bg: colorMotivo.withOpacity(0.10),
                        fg: colorMotivo,
                      ),
                      _Badge(
                        text: petro.estadoTexto,
                        bg: _colorEstado(petro.estado).withOpacity(0.10),
                        fg: _colorEstado(petro.estado),
                      ),
                      _Badge(
                        text: petro.tecnicaGrabado,
                        bg: const Color(0xFFE3EEF8),
                        fg: const Color(0xFF1A5A8F),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const _SectionTitle('Información Técnica'),
                  const SizedBox(height: 10),

                  // Grid de datos técnicos
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.6,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: [
                      _InfoCard(
                        label: 'Tipo de roca',
                        value: petro.tipoRoca,
                        icon: Icons.layers_outlined,
                      ),
                      _InfoCard(
                        label: 'Dimensiones',
                        value: petro.dimensiones.isEmpty
                            ? '—'
                            : '${petro.dimensiones} cm',
                        icon: Icons.straighten_outlined,
                      ),
                      _InfoCard(
                        label: 'Técnica',
                        value: petro.tecnicaGrabado,
                        icon: Icons.build_outlined,
                      ),
                      _InfoCard(
                        label: 'Estado',
                        value: petro.estadoTexto,
                        icon: Icons.health_and_safety_outlined,
                      ),
                    ],
                  ),

                  // Coordenadas (restringidas o visibles según sitio)
                  if (sitio != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: sitio.esRestringido
                            ? const Color(0xFFFEF3E2)
                            : const Color(0xFFE3F2E1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            sitio.esRestringido
                                ? Icons.lock_outline
                                : Icons.place_outlined,
                            size: 18,
                            color: sitio.esRestringido
                                ? const Color(0xFFB87A00)
                                : const Color(0xFF2D5A27),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              sitio.coordenadasPublicas,
                              style: TextStyle(
                                fontSize: 12,
                                color: sitio.esRestringido
                                    ? const Color(0xFFB87A00)
                                    : const Color(0xFF2D5A27),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                  const _SectionTitle('Descripción del motivo'),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Text(
                      petro.descripcion.isEmpty
                          ? 'Sin descripción disponible.'
                          : petro.descripcion,
                      style: const TextStyle(
                          height: 1.6, fontSize: 14, color: Color(0xFF444444)),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const _SectionTitle('Galería multimedia'),
                  const SizedBox(height: 10),

                  // Galería con íconos Material
                  SizedBox(
                    height: 88,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _MediaThumb(
                            icon: Icons.photo_camera,
                            label: 'Foto',
                            color: const Color(0xFF2D5A27)),
                        _MediaThumb(
                            icon: Icons.photo_camera,
                            label: 'Foto',
                            color: const Color(0xFF2D5A27)),
                        _MediaThumb(
                            icon: Icons.photo_camera,
                            label: 'Foto',
                            color: const Color(0xFF2D5A27)),
                        _MediaThumb(
                            icon: Icons.picture_as_pdf,
                            label: 'Calco',
                            color: const Color(0xFFB53030),
                            isPdf: true),
                        _MediaThumb(
                            icon: Icons.lock_outline,
                            label: 'Privado',
                            color: Colors.grey,
                            isRestricted: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Botón descargar archivos públicos
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Descargar archivos públicos'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2D5A27),
                        side: const BorderSide(color: Color(0xFF2D5A27)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers de color e ícono ─────────────────

  IconData _iconMotivo(TipoMotivo t) {
    switch (t) {
      case TipoMotivo.zoomorfo:       return Icons.pets;
      case TipoMotivo.geometrico:     return Icons.change_history;
      case TipoMotivo.antropomorfo:   return Icons.accessibility_new;
      case TipoMotivo.abstracto:      return Icons.auto_awesome;
      case TipoMotivo.noIdentificado: return Icons.help_outline;
    }
  }

  Color _colorMotivo(TipoMotivo t) {
    switch (t) {
      case TipoMotivo.zoomorfo:       return const Color(0xFFB87A00);
      case TipoMotivo.geometrico:     return const Color(0xFF2D5A27);
      case TipoMotivo.antropomorfo:   return const Color(0xFFB53030);
      case TipoMotivo.abstracto:      return const Color(0xFF5341A8);
      case TipoMotivo.noIdentificado: return Colors.grey;
    }
  }

  Color _colorEstado(EstadoConservacion e) {
    switch (e) {
      case EstadoConservacion.muyBueno: return const Color(0xFF2D5A27);
      case EstadoConservacion.bueno:    return const Color(0xFF4A8F42);
      case EstadoConservacion.regular:  return const Color(0xFFB87A00);
      case EstadoConservacion.malo:     return const Color(0xFFB53030);
      case EstadoConservacion.critico:  return Colors.red.shade900;
    }
  }
}

// ─────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF222222)),
      );
}

class _Badge extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;

  const _Badge({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
        child: Text(text,
            style: TextStyle(
                fontSize: 11, color: fg, fontWeight: FontWeight.w500)),
      );
}

class _HeroBadge extends StatelessWidget {
  final String text;
  final IconData? icon;

  const _HeroBadge(this.text, {this.icon});

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: Colors.white),
              const SizedBox(width: 4),
            ],
            Text(text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      );
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoCard(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade500),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 10, color: Colors.grey)),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      );
}

class _MediaThumb extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isPdf;
  final bool isRestricted;

  const _MediaThumb({
    required this.icon,
    required this.label,
    required this.color,
    this.isPdf = false,
    this.isRestricted = false,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: 76,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isRestricted
              ? Colors.grey.shade100
              : (isPdf
                  ? const Color(0xFFFDE8E8)
                  : color.withOpacity(0.10)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: isRestricted ? Colors.grey : color),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: isRestricted ? Colors.grey : color,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      );
}
