// lib/utils/constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Petroglifos Maule';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Registro y difusión del patrimonio arqueológico del Maule';

  // Routes
  static const String routeHome = '/';
  static const String routeCatalog = '/catalog';
  static const String routeDetail = '/detail';
  static const String routeLogin = '/login';
  static const String routeDashboard = '/dashboard';

  // Colors
  static const Color primaryColor = Color(0xFF5D4037);        // Marrón arqueológico
  static const Color secondaryColor = Color(0xFF8D6E63);
  static const Color backgroundColor = Color(0xFFF5F0E6);
  static const Color accentColor = Color(0xFF4E342E);

  // Assets
  static const String imagePath = 'assets/images/';
  static const String defaultImage = 'assets/images/default_petroglifo.jpg';

  // Validation
  static const String codigoPattern = r'^MAU-\d{3}-P\d{2}$'; // Ej: MAU-001-P03

  // Messages
  static const String saveSuccess = 'Guardado correctamente';
  static const String updateSuccess = 'Actualizado correctamente';
  static const String deleteSuccess = 'Eliminado correctamente';
  static const String errorMessage = 'Ocurrió un error. Inténtelo nuevamente.';

  // Offline
  static const String boxSitios = 'sitios';
  static const String boxPetroglifos = 'petroglifos';
  static const String boxVisitas       = 'visitas';
  static const String boxUsuarios = 'usuarios';

  // ── Credenciales demo (solo para desarrollo) ─
  static const String demoAdminEmail   = 'felipe@patrimonio.cl';
  static const String demoInvEmail     = 'pablo@patrimonio.cl';
  static const String demoPassword     = '1234';
}

class AppStrings {
  static const String noImageAvailable = 'Sin imagen disponible';
  static const String restrictedSite = 'Sitio de acceso restringido';
  static const String publicCatalog = 'Catálogo Público';
}