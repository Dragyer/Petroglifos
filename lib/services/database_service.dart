import 'package:hive_flutter/hive_flutter.dart';
import '../models/sitio.dart';
import '../models/petroglifo.dart';
import '../models/visita.dart';
import '../models/usuario.dart';
import '../utils/constants.dart';
import 'mock_data.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance ??= DatabaseService._();
  DatabaseService._();

  late Box<Sitio>       sitiosBox;
  late Box<Petroglifo>  petroglifosBox;
  late Box<Visita>      visitasBox;
  late Box<Usuario>     usuariosBox;

  // ─────────────────────────────────────────────
  // Init
  // ─────────────────────────────────────────────

  Future<void> init() async {
    await Hive.initFlutter();

    // Registrar adaptadores
    Hive.registerAdapter(SitioAdapter());
    Hive.registerAdapter(PetroglifoAdapter());
    Hive.registerAdapter(TipoMotivoAdapter());
    Hive.registerAdapter(EstadoConservacionAdapter());
    Hive.registerAdapter(VisibilidadAdapter());
    Hive.registerAdapter(VisitaAdapter());
    Hive.registerAdapter(UsuarioAdapter());
    Hive.registerAdapter(RolUsuarioAdapter());

    // Abrir cajas
    sitiosBox       = await Hive.openBox<Sitio>(AppConstants.boxSitios);
    petroglifosBox  = await Hive.openBox<Petroglifo>(AppConstants.boxPetroglifos);
    visitasBox      = await Hive.openBox<Visita>(AppConstants.boxVisitas);
    usuariosBox     = await Hive.openBox<Usuario>(AppConstants.boxUsuarios);

    // Seed si está vacío
    if (sitiosBox.isEmpty) await _loadMockData();
  }

  Future<void> _loadMockData() async {
    for (final s in mockSitios)       { await sitiosBox.put(s.id, s); }
    for (final p in mockPetroglifos)  { await petroglifosBox.put(p.id, p); }
    for (final u in mockUsuarios)     { await usuariosBox.put(u.id, u); }
  }

  // ─────────────────────────────────────────────
  // CRUD Sitios
  // ─────────────────────────────────────────────

  List<Sitio>          getAllSitios()                      => sitiosBox.values.toList();
  List<Sitio>          getSitiosActivos()                  => sitiosBox.values.where((s) => s.estaActivo).toList();
  Sitio?               getSitioById(String id)             => sitiosBox.get(id);
  Future<void>         saveSitio(Sitio s)                  => sitiosBox.put(s.id, s);
  Future<void>         deleteSitio(String id)              => sitiosBox.delete(id);

  /// Soft-delete: cambia estado a inactivo (CU-14)
  Future<void> desactivarSitio(String id) async {
    final sitio = sitiosBox.get(id);
    if (sitio != null) {
      sitio.estaActivo = false;
      await sitio.save();
    }
  }

  // ─────────────────────────────────────────────
  // CRUD Petroglifos
  // ─────────────────────────────────────────────

  List<Petroglifo>     getAllPetroglifos()                     => petroglifosBox.values.toList();
  List<Petroglifo>     getPetroglifosPublicos()                => petroglifosBox.values.where((p) => p.esVisible && p.estaActivo).toList();
  List<Petroglifo>     getPetroglifosBySitio(String sitioId)   => petroglifosBox.values.where((p) => p.sitioId == sitioId).toList();
  Petroglifo?          getPetroglifoById(String id)            => petroglifosBox.get(id);
  Future<void>         savePetroglifo(Petroglifo p)            => petroglifosBox.put(p.id, p);
  Future<void>         deletePetroglifo(String id)             => petroglifosBox.delete(id);

  /// Busca por código, tipo de motivo o descripción
  List<Petroglifo> searchPetroglifos(String query) {
    final q = query.toLowerCase();
    return petroglifosBox.values.where((p) =>
        p.codigo.toLowerCase().contains(q) ||
        p.tipoMotivoTexto.toLowerCase().contains(q) ||
        p.descripcion.toLowerCase().contains(q)).toList();
  }

  // ─────────────────────────────────────────────
  // CRUD Visitas
  // ─────────────────────────────────────────────

  List<Visita>  getAllVisitas()                     => visitasBox.values.toList();
  List<Visita>  getVisitasBySitio(String sitioId)   => visitasBox.values.where((v) => v.sitioId == sitioId).toList();
  Future<void>  saveVisita(Visita v)                => visitasBox.put(v.id, v);
  Future<void>  deleteVisita(String id)             => visitasBox.delete(id);

  // ─────────────────────────────────────────────
  // CRUD Usuarios
  // ─────────────────────────────────────────────

  List<Usuario>  getAllUsuarios()               => usuariosBox.values.toList();
  Usuario?       getUsuarioById(String id)      => usuariosBox.get(id);
  Future<void>   saveUsuario(Usuario u)         => usuariosBox.put(u.id, u);

  /// Login simple (v1.0 sin recuperación automática)
  Usuario? login(String email, String password) {
    // En producción esto se compararía con hash almacenado
    if (password != AppConstants.demoPassword) return null;
    try {
      return usuariosBox.values.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase() && u.estaActivo,
      );
    } catch (_) {
      return null;
    }
  }

  // ─────────────────────────────────────────────
  // Utilidades
  // ─────────────────────────────────────────────

  Future<void> clearAll() async {
    await sitiosBox.clear();
    await petroglifosBox.clear();
    await visitasBox.clear();
    await usuariosBox.clear();
  }
}