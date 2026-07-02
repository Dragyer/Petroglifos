import 'package:flutter/material.dart';
import '../../models/petroglifo.dart';
import '../../models/sitio.dart';
import '../../models/visita.dart';
import '../../services/database_service.dart';

// ─────────────────────────────────────────────
// Pantalla principal de reportes (CU-15, CU-20)
// ─────────────────────────────────────────────

class ReportesScreen extends StatefulWidget {
  const ReportesScreen({super.key});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: AppBar(
        title: const Text('Reportes del Sistema'),
        backgroundColor: const Color(0xFF1A3A17),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(icon: Icon(Icons.bar_chart, size: 18), text: 'Resumen'),
            Tab(icon: Icon(Icons.landscape, size: 18), text: 'Sitios'),
            Tab(icon: Icon(Icons.article, size: 18), text: 'Petroglifos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _TabResumen(),
          _TabSitios(),
          _TabPetroglifos(),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// TAB 1 — Resumen general (CU-20)
// ══════════════════════════════════════════════

class _TabResumen extends StatelessWidget {
  const _TabResumen();

  @override
  Widget build(BuildContext context) {
    final db       = DatabaseService.instance;
    final sitios   = db.getAllSitios();
    final petros   = db.getAllPetroglifos();
    final visitas  = db.getAllVisitas();
    final usuarios = db.getAllUsuarios();

    // Métricas derivadas
    final sitiosActivos    = sitios.where((s) => s.estaActivo).length;
    final sitiosRestringidos = sitios.where((s) => s.esRestringido).length;
    final petrosActivos    = petros.where((p) => p.estaActivo).length;
    final petrosPublicos   = petros.where((p) => p.esVisible).length;
    final petrosCriticos   = petros
        .where((p) => p.estado == EstadoConservacion.critico ||
                      p.estado == EstadoConservacion.malo)
        .length;

    // Distribución por tipo de motivo
    final Map<TipoMotivo, int> porMotivo = {};
    for (final p in petros) {
      porMotivo[p.tipoMotivo] = (porMotivo[p.tipoMotivo] ?? 0) + 1;
    }

    // Distribución por estado
    final Map<EstadoConservacion, int> porEstado = {};
    for (final p in petros) {
      porEstado[p.estado] = (porEstado[p.estado] ?? 0) + 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fecha del reporte
          _ReporteHeader(
            titulo: 'Informe General del Sistema',
            subtitulo: 'Generado: ${_fechaHoy()}',
          ),

          const SizedBox(height: 14),

          // KPIs principales
          const _SectionLabel('Indicadores clave'),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.55,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _KpiCard(
                label: 'Sitios activos',
                value: sitiosActivos.toString(),
                total: sitios.length,
                icon: Icons.map_outlined,
                color: const Color(0xFF2D5A27),
              ),
              _KpiCard(
                label: 'Petroglifos registrados',
                value: petrosActivos.toString(),
                total: petros.length,
                icon: Icons.article_outlined,
                color: const Color(0xFF1A5A8F),
              ),
              _KpiCard(
                label: 'Fichas públicas',
                value: petrosPublicos.toString(),
                total: petros.length,
                icon: Icons.visibility_outlined,
                color: const Color(0xFF4A8F42),
              ),
              _KpiCard(
                label: 'En estado crítico',
                value: petrosCriticos.toString(),
                total: petros.length,
                icon: Icons.warning_amber_outlined,
                color: const Color(0xFFB53030),
                alerta: petrosCriticos > 0,
              ),
            ],
          ),

          const SizedBox(height: 18),
          const _SectionLabel('Distribución por tipo de motivo'),
          const SizedBox(height: 8),
          _BarChart(
            datos: porMotivo.entries
                .map((e) => _BarDato(
                      label: _labelMotivo(e.key),
                      valor: e.value,
                      color: _colorMotivo(e.key),
                    ))
                .toList(),
            total: petros.isEmpty ? 1 : petros.length,
          ),

          const SizedBox(height: 18),
          const _SectionLabel('Estado de conservación'),
          const SizedBox(height: 8),
          _BarChart(
            datos: porEstado.entries
                .map((e) => _BarDato(
                      label: _labelEstado(e.key),
                      valor: e.value,
                      color: _colorEstado(e.key),
                    ))
                .toList(),
            total: petros.isEmpty ? 1 : petros.length,
          ),

          const SizedBox(height: 18),
          const _SectionLabel('Actividad del sistema'),
          const SizedBox(height: 8),
          _ActividadRow(
              icon: Icons.calendar_today_outlined,
              label: 'Visitas de campo registradas',
              valor: visitas.length.toString(),
              color: const Color(0xFFB87A00)),
          _ActividadRow(
              icon: Icons.people_outline,
              label: 'Investigadores activos',
              valor: usuarios.where((u) => u.estaActivo).length.toString(),
              color: const Color(0xFF5341A8)),
          _ActividadRow(
              icon: Icons.lock_outline,
              label: 'Sitios restringidos',
              valor: sitiosRestringidos.toString(),
              color: const Color(0xFFB87A00)),
          _ActividadRow(
              icon: Icons.public,
              label: 'Fichas visibles al público',
              valor: petrosPublicos.toString(),
              color: const Color(0xFF2D5A27)),

          const SizedBox(height: 18),
          _BotonExportar(titulo: 'Exportar resumen general'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// TAB 2 — Reporte de Sitios
// ══════════════════════════════════════════════

class _TabSitios extends StatelessWidget {
  const _TabSitios();

  @override
  Widget build(BuildContext context) {
    final db     = DatabaseService.instance;
    final sitios = db.getAllSitios();

    // Sitios con más petroglifos
    final conPetros = sitios.map((s) {
      final count = db.getPetroglifosBySitio(s.id).length;
      return _SitioMetrica(sitio: s, totalPetros: count);
    }).toList()
      ..sort((a, b) => b.totalPetros.compareTo(a.totalPetros));

    // Por comuna
    final Map<String, int> porComuna = {};
    for (final s in sitios) {
      porComuna[s.comuna] = (porComuna[s.comuna] ?? 0) + 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReporteHeader(
            titulo: 'Reporte de Sitios Arqueológicos',
            subtitulo: '${sitios.length} sitios · ${_fechaHoy()}',
          ),

          const SizedBox(height: 14),
          const _SectionLabel('Sitios por cantidad de petroglifos'),
          const SizedBox(height: 8),

          ...conPetros.map((m) => _SitioReporteCard(metrica: m)),

          const SizedBox(height: 18),
          const _SectionLabel('Distribución por comuna'),
          const SizedBox(height: 8),
          _BarChart(
            datos: porComuna.entries
                .map((e) => _BarDato(
                      label: e.key,
                      valor: e.value,
                      color: const Color(0xFF2D5A27),
                    ))
                .toList(),
            total: sitios.isEmpty ? 1 : sitios.length,
          ),

          const SizedBox(height: 18),
          const _SectionLabel('Resumen de acceso'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _MiniKpi(
                  label: 'Acceso público',
                  valor: sitios.where((s) => !s.esRestringido).length,
                  color: const Color(0xFF2D5A27),
                  icon: Icons.public,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniKpi(
                  label: 'Restringidos',
                  valor: sitios.where((s) => s.esRestringido).length,
                  color: const Color(0xFFB87A00),
                  icon: Icons.lock_outline,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniKpi(
                  label: 'Inactivos',
                  valor: sitios.where((s) => !s.estaActivo).length,
                  color: Colors.grey,
                  icon: Icons.block,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          _BotonExportar(titulo: 'Exportar reporte de sitios'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// TAB 3 — Reporte de Petroglifos
// ══════════════════════════════════════════════

class _TabPetroglifos extends StatelessWidget {
  const _TabPetroglifos();

  @override
  Widget build(BuildContext context) {
    final db     = DatabaseService.instance;
    final petros = db.getAllPetroglifos();

    // Los que necesitan atención (malo o crítico)
    final atencion = petros
        .where((p) =>
            p.estado == EstadoConservacion.malo ||
            p.estado == EstadoConservacion.critico)
        .toList();

    // Distribución por tipo de roca
    final Map<String, int> porRoca = {};
    for (final p in petros) {
      porRoca[p.tipoRoca] = (porRoca[p.tipoRoca] ?? 0) + 1;
    }

    // Distribución por técnica
    final Map<String, int> porTecnica = {};
    for (final p in petros) {
      porTecnica[p.tecnicaGrabado] =
          (porTecnica[p.tecnicaGrabado] ?? 0) + 1;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReporteHeader(
            titulo: 'Reporte de Petroglifos',
            subtitulo: '${petros.length} fichas · ${_fechaHoy()}',
          ),

          // Alerta si hay piezas críticas
          if (atencion.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFDE8E8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFB53030).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Color(0xFFB53030), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${atencion.length} petroglifo${atencion.length > 1 ? 's' : ''} '
                      'en estado malo o crítico requiere${atencion.length > 1 ? 'n' : ''} atención urgente.',
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFFB53030)),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),
          const _SectionLabel('Fichas que requieren atención'),
          const SizedBox(height: 8),

          if (atencion.isEmpty)
            _EmptyCard(
                mensaje: 'Ningún petroglifo en estado crítico. ✅',
                color: const Color(0xFF2D5A27))
          else
            ...atencion.map((p) => _PetroAtencionCard(petro: p)),

          const SizedBox(height: 18),
          const _SectionLabel('Tipo de roca soporte'),
          const SizedBox(height: 8),
          _BarChart(
            datos: porRoca.entries
                .map((e) => _BarDato(
                      label: e.key,
                      valor: e.value,
                      color: const Color(0xFF5341A8),
                    ))
                .toList(),
            total: petros.isEmpty ? 1 : petros.length,
          ),

          const SizedBox(height: 18),
          const _SectionLabel('Técnica de grabado'),
          const SizedBox(height: 8),
          _BarChart(
            datos: porTecnica.entries
                .map((e) => _BarDato(
                      label: e.key,
                      valor: e.value,
                      color: const Color(0xFF1A5A8F),
                    ))
                .toList(),
            total: petros.isEmpty ? 1 : petros.length,
          ),

          const SizedBox(height: 18),
          const _SectionLabel('Visibilidad pública'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _MiniKpi(
                  label: 'Completa',
                  valor: petros
                      .where((p) => p.visibilidad == Visibilidad.completa)
                      .length,
                  color: const Color(0xFF2D5A27),
                  icon: Icons.visibility,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniKpi(
                  label: 'Solo básico',
                  valor: petros
                      .where((p) => p.visibilidad == Visibilidad.basica)
                      .length,
                  color: const Color(0xFFB87A00),
                  icon: Icons.visibility_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MiniKpi(
                  label: 'Ocultas',
                  valor: petros
                      .where((p) => p.visibilidad == Visibilidad.noMostrar)
                      .length,
                  color: Colors.grey,
                  icon: Icons.visibility_off_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          _BotonExportar(titulo: 'Exportar reporte de petroglifos'),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════
// Widgets reutilizables del módulo de reportes
// ══════════════════════════════════════════════

// Encabezado de reporte
class _ReporteHeader extends StatelessWidget {
  final String titulo;
  final String subtitulo;

  const _ReporteHeader({required this.titulo, required this.subtitulo});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A3A17),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.assessment_outlined,
                color: Colors.white70, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitulo,
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      );
}

// Etiqueta de sección
class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            letterSpacing: 0.5),
      );
}

// KPI grande con porcentaje
class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final int total;
  final IconData icon;
  final Color color;
  final bool alerta;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.total,
    required this.icon,
    required this.color,
    this.alerta = false,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (int.tryParse(value) ?? 0) / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: alerta
              ? color.withOpacity(0.4)
              : Colors.grey.shade100,
          width: alerta ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              if (alerta)
                Icon(Icons.circle, color: color, size: 8),
            ],
          ),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: color)),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600),
              maxLines: 2),
          const SizedBox(height: 6),
          // Barra de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct.clamp(0.0, 1.0),
              backgroundColor: color.withOpacity(0.10),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

// KPI pequeño
class _MiniKpi extends StatelessWidget {
  final String label;
  final int valor;
  final Color color;
  final IconData icon;

  const _MiniKpi({
    required this.label,
    required this.valor,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(valor.toString(),
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      );
}

// Fila de actividad
class _ActividadRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;
  final Color color;

  const _ActividadRow({
    required this.icon,
    required this.label,
    required this.valor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF333333))),
            ),
            Text(valor,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
      );
}

// Barra horizontal de distribución
class _BarChart extends StatelessWidget {
  final List<_BarDato> datos;
  final int total;

  const _BarChart({required this.datos, required this.total});

  @override
  Widget build(BuildContext context) {
    final sorted = [...datos]..sort((a, b) => b.valor.compareTo(a.valor));

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: sorted.map((d) {
          final pct = total > 0 ? d.valor / total : 0.0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(d.label,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF444444))),
                    ),
                    Text('${d.valor}  ',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: d.color)),
                    Text('(${(pct * 100).toStringAsFixed(0)}%)',
                        style: const TextStyle(
                            fontSize: 11, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: pct.clamp(0.0, 1.0),
                    backgroundColor: d.color.withOpacity(0.10),
                    valueColor: AlwaysStoppedAnimation(d.color),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Tarjeta de sitio en reporte
class _SitioReporteCard extends StatelessWidget {
  final _SitioMetrica metrica;

  const _SitioReporteCard({required this.metrica});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2E1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.map_outlined,
                  color: Color(0xFF2D5A27), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(metrica.sitio.nombre,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  Text(
                      '${metrica.sitio.codigo} · ${metrica.sitio.comuna}',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(metrica.totalPetros.toString(),
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D5A27))),
                const Text('petroglifos',
                    style:
                        TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ],
        ),
      );
}

// Tarjeta de petroglifo en alerta
class _PetroAtencionCard extends StatelessWidget {
  final Petroglifo petro;

  const _PetroAtencionCard({required this.petro});

  @override
  Widget build(BuildContext context) {
    final esCritico = petro.estado == EstadoConservacion.critico;
    final color =
        esCritico ? const Color(0xFFB53030) : const Color(0xFFB87A00);
    final sitio = DatabaseService.instance.getSitioById(petro.sitioId);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              esCritico ? Icons.warning_amber_rounded : Icons.report_outlined,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(petro.codigo,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
                Text(
                    sitio != null
                        ? '${sitio.nombre} · ${sitio.comuna}'
                        : petro.sitioId,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(petro.estadoTexto,
                style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// Card vacío
class _EmptyCard extends StatelessWidget {
  final String mensaje;
  final Color color;

  const _EmptyCard({required this.mensaje, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Text(mensaje,
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontSize: 13)),
      );
}

// Botón exportar (simulado)
class _BotonExportar extends StatelessWidget {
  final String titulo;

  const _BotonExportar({required this.titulo});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('📄 $titulo generado'),
                backgroundColor: const Color(0xFF2D5A27),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: const Icon(Icons.download_outlined),
          label: Text(titulo),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1A3A17),
            side: const BorderSide(color: Color(0xFF1A3A17)),
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );
}

// ─────────────────────────────────────────────
// Modelos de dato interno
// ─────────────────────────────────────────────

class _BarDato {
  final String label;
  final int valor;
  final Color color;

  const _BarDato(
      {required this.label, required this.valor, required this.color});
}

class _SitioMetrica {
  final Sitio sitio;
  final int totalPetros;

  const _SitioMetrica({required this.sitio, required this.totalPetros});
}

// ─────────────────────────────────────────────
// Helpers de label/color (locales)
// ─────────────────────────────────────────────

String _fechaHoy() {
  final d = DateTime.now();
  return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

String _labelMotivo(TipoMotivo t) {
  switch (t) {
    case TipoMotivo.geometrico:     return 'Geométrico';
    case TipoMotivo.zoomorfo:       return 'Zoomorfo';
    case TipoMotivo.antropomorfo:   return 'Antropomorfo';
    case TipoMotivo.abstracto:      return 'Abstracto';
    case TipoMotivo.noIdentificado: return 'No identificado';
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

String _labelEstado(EstadoConservacion e) {
  switch (e) {
    case EstadoConservacion.muyBueno: return 'Muy bueno';
    case EstadoConservacion.bueno:    return 'Bueno';
    case EstadoConservacion.regular:  return 'Regular';
    case EstadoConservacion.malo:     return 'Malo';
    case EstadoConservacion.critico:  return 'Crítico';
  }
}

Color _colorEstado(EstadoConservacion e) {
  switch (e) {
    case EstadoConservacion.muyBueno: return const Color(0xFF2D5A27);
    case EstadoConservacion.bueno:    return const Color(0xFF4A8F42);
    case EstadoConservacion.regular:  return const Color(0xFFB87A00);
    case EstadoConservacion.malo:     return const Color(0xFFB53030);
    case EstadoConservacion.critico:  return Colors.red;
  }
}
