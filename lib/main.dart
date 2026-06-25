import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme.dart';
import 'screens/public/home_screen.dart';
import 'screens/public/catalog_screen.dart';
import 'screens/public/detail_screen.dart';
import 'screens/admin/login_screen.dart';
import 'screens/admin/dashboard_screen.dart';

void main() {
  runApp(const PetroglifosMauleApp());
}

class PetroglifosMauleApp extends StatelessWidget {
  const PetroglifosMauleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const PublicHomeScreen()),
        GoRoute(path: '/catalog', builder: (context, state) => const CatalogScreen()),
        GoRoute(
          path: '/detail/:id',
          builder: (context, state) => DetailScreen(petroId: state.pathParameters['id']!),
        ),
        GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
      ],
    );

    return MaterialApp.router(
      title: 'Petroglifos Maule',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}