// lib/services/database_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/sitio.dart';
import '../models/petroglifo.dart';
import '../utils/constants.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance => _instance ??= DatabaseService._();

  DatabaseService._();

  late Box<Sitio> sitiosBox;
  late Box<Petroglifo> petroglifosBox;

  Future<void> init() async {
    await Hive.initFlutter();

    // Registrar adaptadores
    Hive.registerAdapter(SitioAdapter());
    Hive.registerAdapter(PetroglifoAdapter());
    Hive.registerAdapter(TipoMotivoAdapter());
    Hive.registerAdapter(EstadoConservacionAdapter());
    Hive.registerAdapter(VisibilidadAdapter());

    // Abrir cajas
    sitiosBox = await Hive.openBox<Sitio>(AppConstants.boxSitios);
    petroglifosBox = await Hive.openBox<Petroglifo>(AppConstants.boxPetroglifos);

    // Cargar datos mock si está vacío
    if (sitiosBox.isEmpty) {
      await _loadMockData();
    }
  }

  Future<void> _loadMockData() async {
    // Mock Sitios
    final mockSitios = [
      Sitio(
        id: 's1',
        nombre: 'Afloramiento Linares',
        codigo: 'MAU-001',
        comuna: 'Linares',
        descripcion: 'Cerro con grabados precolombinos en la precordillera.',
        lat: -35.85,
        lng: -71.55,
        esRestringido: true,
      ),
    ];

    for (var sitio in mockSitios) {
      await sitiosBox.put(sitio.id, sitio);
    }

    // Mock Petroglifos
    final mockPetros = [
      Petroglifo(
        id: 'p1',
        codigo: 'MAU-001-P03',
        sitioId: 's1',
        tipoRoca: 'Granito',
        dimensiones: '120 × 80 cm',
        tecnicaGrabado: 'Percusión directa',
        tipoMotivo: TipoMotivo.zoomorfo,
        descripcion: 'Figura zoomorfa estilizada, posiblemente un felino.',
        estado: EstadoConservacion.regular,
        visibilidad: Visibilidad.basica,
        imagenPrincipal: 'assets/images/petro1.jpg',
      ),
      Petroglifo(
        id: 'p2',
        codigo: 'MAU-001-P04',
        sitioId: 's1',
        tipoRoca: 'Arenisca',
        dimensiones: '95 × 65 cm',
        tecnicaGrabado: 'Abrasión',
        tipoMotivo: TipoMotivo.geometrico,
        descripcion: 'Motivo geométrico circular con líneas concéntricas.',
        estado: EstadoConservacion.bueno,
        visibilidad: Visibilidad.completa,
        imagenPrincipal: 'assets/images/petro3.jpg',
      ),
    ];

    for (var petro in mockPetros) {
      await petroglifosBox.put(petro.id, petro);
    }
  }

  // ==================== CRUD Sitios ====================
  List<Sitio> getAllSitios() => sitiosBox.values.toList();
  Future<void> saveSitio(Sitio sitio) => sitiosBox.put(sitio.id, sitio);
  Future<void> deleteSitio(String id) => sitiosBox.delete(id);

  // ==================== CRUD Petroglifos ====================
  List<Petroglifo> getAllPetroglifos() => petroglifosBox.values.toList();
  List<Petroglifo> getPetroglifosBySitio(String sitioId) =>
      petroglifosBox.values.where((p) => p.sitioId == sitioId).toList();

  Future<void> savePetroglifo(Petroglifo petro) => petroglifosBox.put(petro.id, petro);
  Future<void> deletePetroglifo(String id) => petroglifosBox.delete(id);

  Future<void> clearAll() async {
    await sitiosBox.clear();
    await petroglifosBox.clear();
  }
}