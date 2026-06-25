import '../models/sitio.dart';
import '../models/petroglifo.dart';

final List<Sitio> mockSitios = [
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

final List<Petroglifo> mockPetroglifos = [
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
    imagenesPublicas: ['assets/images/petro1.jpg', 'assets/images/petro2.jpg'],
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