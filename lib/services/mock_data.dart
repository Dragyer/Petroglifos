import '../models/sitio.dart';
import '../models/petroglifo.dart';
import '../models/visita.dart';
import '../models/usuario.dart';

// ─────────────────────────────────────────────
// Sitios arqueológicos de ejemplo
// ─────────────────────────────────────────────

final List<Sitio> mockSitios = [
  Sitio(
    id: 's1',
    nombre: 'Afloramiento Linares',
    codigo: 'MAU-001',
    comuna: 'Linares',
    descripcion: 'Cerro con grabados precolombinos en la precordillera de Linares.',
    lat: -35.85,
    lng: -71.55,
    esRestringido: true,
    responsable: 'Felipe',
  ),
  Sitio(
    id: 's2',
    nombre: 'Cerro Quiahue',
    codigo: 'MAU-003',
    comuna: 'Linares',
    descripcion: 'Afloramiento rocoso con concentración de grabados zoomorfos.',
    lat: -35.91,
    lng: -71.48,
    esRestringido: false,
    responsable: 'Pablo',
  ),
  Sitio(
    id: 's3',
    nombre: 'Altos del Achibueno',
    codigo: 'MAU-007',
    comuna: 'Parral',
    descripcion: 'Sitio con petroglifos geométricos de gran tamaño.',
    lat: -36.12,
    lng: -71.82,
    esRestringido: true,
    responsable: 'Felipe',
  ),
];

// ─────────────────────────────────────────────
// Petroglifos de ejemplo
// ─────────────────────────────────────────────

final List<Petroglifo> mockPetroglifos = [
  Petroglifo(
    id: 'p1',
    codigo: 'MAU-003-P01',
    sitioId: 's2',
    tipoRoca: 'Granito',
    dimensiones: '120 × 80 cm',
    tecnicaGrabado: 'Percusión directa',
    tipoMotivo: TipoMotivo.zoomorfo,
    descripcion:
        'Figura zoomorfa de posible representación de camélido. Se observan líquenes en sector inferior derecho que afectan la visibilidad del grabado.',
    estado: EstadoConservacion.regular,
    visibilidad: Visibilidad.basica,
    imagenPrincipal: null,
    imagenesPublicas: [],
    fechaRegistro: DateTime(2023, 3, 12),
  ),
  Petroglifo(
    id: 'p2',
    codigo: 'MAU-001-P04',
    sitioId: 's1',
    tipoRoca: 'Arenisca',
    dimensiones: '95 × 65 cm',
    tecnicaGrabado: 'Abrasión',
    tipoMotivo: TipoMotivo.geometrico,
    descripcion:
        'Motivo geométrico circular con líneas concéntricas. Excelente estado de visibilidad.',
    estado: EstadoConservacion.bueno,
    visibilidad: Visibilidad.completa,
    imagenPrincipal: null,
    imagenesPublicas: [],
    fechaRegistro: DateTime(2023, 5, 20),
  ),
  Petroglifo(
    id: 'p3',
    codigo: 'MAU-007-P02',
    sitioId: 's3',
    tipoRoca: 'Granito',
    dimensiones: '200 × 150 cm',
    tecnicaGrabado: 'Percusión indirecta',
    tipoMotivo: TipoMotivo.antropomorfo,
    descripcion:
        'Figura antropomorfa de gran tamaño. Posiblemente asociada a rituales de la cultura local.',
    estado: EstadoConservacion.muyBueno,
    visibilidad: Visibilidad.completa,
    imagenPrincipal: null,
    imagenesPublicas: [],
    fechaRegistro: DateTime(2023, 8, 4),
  ),
  Petroglifo(
    id: 'p4',
    codigo: 'MAU-001-P03',
    sitioId: 's1',
    tipoRoca: 'Pizarra',
    dimensiones: '45 × 38 cm',
    tecnicaGrabado: 'Mixto',
    tipoMotivo: TipoMotivo.abstracto,
    descripcion:
        'Composición abstracta de líneas paralelas y puntos incisos. Significado indeterminado.',
    estado: EstadoConservacion.malo,
    visibilidad: Visibilidad.basica,
    imagenPrincipal: null,
    imagenesPublicas: [],
    fechaRegistro: DateTime(2024, 1, 15),
  ),
];

// ─────────────────────────────────────────────
// Visitas de ejemplo
// ─────────────────────────────────────────────

final List<Visita> mockVisitas = [
  Visita(
    id: 'v1',
    sitioId: 's2',
    investigadorId: 'u1',
    fecha: DateTime(2024, 3, 10),
    observaciones:
        'Visita de prospección. Se registraron 4 nuevos petroglifos. Acceso en buen estado.',
    hallazgos: ['Nuevo petroglifo zoomorfo sector norte', 'Fragmento cerámica'],
  ),
];

// ─────────────────────────────────────────────
// Usuarios de ejemplo
// ─────────────────────────────────────────────

final List<Usuario> mockUsuarios = [
  Usuario(
    id: 'u1',
    nombre: 'Felipe Investigador',
    email: 'felipe@patrimonio.cl',
    run: '12.345.678-9',
    rol: RolUsuario.administrador,
  ),
  Usuario(
    id: 'u2',
    nombre: 'Pablo Colaborador',
    email: 'pablo@patrimonio.cl',
    run: '9.876.543-2',
    rol: RolUsuario.investigador,
  ),
];
