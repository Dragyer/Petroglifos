import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/database_service.dart';
import '../../models/petroglifo.dart';

class PublicHomeScreen extends StatefulWidget {
  const PublicHomeScreen({super.key});

  @override
  State<PublicHomeScreen> createState() => _PublicHomeScreenState();
}

class _PublicHomeScreenState extends State<PublicHomeScreen> {
  List<Petroglifo> _petros = [];
  int _totalSitios = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final db = DatabaseService.instance;
    setState(() {
      _petros      = db.getPetroglifosPublicos();
      _totalSitios = db.getAllSitios().length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      body: CustomScrollView(
        slivers: [
          // ── Hero banner ───────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A3A17), Color(0xFF2D5A27), Color(0xFF4A8F42)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.landscape,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Petroglifos Maule',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3)),
                          Text('Patrimonio arqueológico del Maule',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Buscador rápido
                  GestureDetector(
                    onTap: () => context.push('/catalog'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search,
                              color: Colors.grey.shade500, size: 20),
                          const SizedBox(width: 10),
                          Text('Buscar petroglifos, sitios...',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Tarjetas de estadísticas ──────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
              child: Row(
                children: [
                  _StatCard(
                    number: _totalSitios.toString(),
                    label: 'Sitios',
                    icon: Icons.map_outlined,
                    color: const Color(0xFF2D5A27),
                  ),
                  _StatCard(
                    number: _petros.length.toString(),
                    label: 'Petroglifos',
                    icon: Icons.article_outlined,
                    color: const Color(0xFF1A5A8F),
                  ),
                  _StatCard(
                    number: '512',
                    label: 'Archivos',
                    icon: Icons.photo_library_outlined,
                    color: const Color(0xFFB87A00),
                  ),
                ],
              ),
            ),
          ),

          // ── Accesos rápidos ──────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                children: [
                  _QuickAction(
                    icon: Icons.grid_view_rounded,
                    label: 'Ver catálogo',
                    color: const Color(0xFF2D5A27),
                    onTap: () => context.push('/catalog'),
                  ),
                  const SizedBox(width: 10),
                  _QuickAction(
                    icon: Icons.place_outlined,
                    label: 'Explorar sitios',
                    color: const Color(0xFF1A5A8F),
                    onTap: () => context.push('/catalog'),
                  ),
                  const SizedBox(width: 10),
                  _QuickAction(
                    icon: Icons.login_rounded,
                    label: 'Iniciar sesión',
                    color: const Color(0xFF5341A8),
                    onTap: () => context.push('/login'),
                  ),
                ],
              ),
            ),
          ),

          // ── Título sección ───────────────────
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Últimos registros',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333))),
            ),
          ),

          // ── Lista de petroglifos ─────────────
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                if (i >= _petros.length) return null;
                final p = _petros[i];
                return _PetroListTile(
                  petro: p,
                  onTap: () => context.push('/detail/${p.id}'),
                );
              },
              childCount: _petros.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Widgets internos
// ─────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String number;
  final String label;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.number,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(number,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color)),
              Text(label,
                  style: const TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
      );
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 5),
                Text(label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      );
}

class _PetroListTile extends StatelessWidget {
  final Petroglifo petro;
  final VoidCallback onTap;

  const _PetroListTile({required this.petro, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 1))
          ],
        ),
        child: Row(
          children: [
            // Ícono visual con color por tipo
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _colorMotivo(petro.tipoMotivo).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _iconMotivo(petro.tipoMotivo),
                color: _colorMotivo(petro.tipoMotivo),
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(petro.codigo,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(
                    _sitioNombre(petro.sitioId),
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      _Badge(
                        text: petro.tipoMotivoTexto,
                        bg: _colorMotivo(petro.tipoMotivo).withOpacity(0.12),
                        fg: _colorMotivo(petro.tipoMotivo),
                      ),
                      const SizedBox(width: 6),
                      _Badge(
                        text: petro.estadoTexto,
                        bg: _colorEstado(petro.estado).withOpacity(0.12),
                        fg: _colorEstado(petro.estado),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }

  String _sitioNombre(String sitioId) {
    final sitio = DatabaseService.instance.getSitioById(sitioId);
    return sitio != null ? '${sitio.nombre} · ${sitio.comuna}' : sitioId;
  }

  IconData _iconMotivo(TipoMotivo t) {
    switch (t) {
      case TipoMotivo.zoomorfo:      return Icons.pets;
      case TipoMotivo.geometrico:    return Icons.change_history;
      case TipoMotivo.antropomorfo:  return Icons.accessibility_new;
      case TipoMotivo.abstracto:     return Icons.auto_awesome;
      case TipoMotivo.noIdentificado: return Icons.help_outline;
    }
  }

  Color _colorMotivo(TipoMotivo t) {
    switch (t) {
      case TipoMotivo.zoomorfo:      return const Color(0xFFB87A00);
      case TipoMotivo.geometrico:    return const Color(0xFF2D5A27);
      case TipoMotivo.antropomorfo:  return const Color(0xFFB53030);
      case TipoMotivo.abstracto:     return const Color(0xFF5341A8);
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

class _Badge extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;

  const _Badge({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
        child: Text(text, style: TextStyle(fontSize: 10, color: fg, fontWeight: FontWeight.w500)),
      );
}
