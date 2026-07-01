import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme.dart';
import 'services/database_service.dart';
import 'screens/public/home_screen.dart';
import 'screens/public/catalog_screen.dart';
import 'screens/public/detail_screen.dart';
import 'screens/admin/login_screen.dart';
import 'screens/admin/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.init();
  runApp(const PetroglifosMauleApp());
}

class PetroglifosMauleApp extends StatelessWidget {
  const PetroglifosMauleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        // ── Visor público ──────────────────────
        ShellRoute(
          builder: (context, state, child) =>
              _PublicShell(child: child),
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const PublicHomeScreen(),
            ),
            GoRoute(
              path: '/catalog',
              builder: (context, state) => const CatalogScreen(),
            ),
          ],
        ),

        // ── Detalle (sin shell para SliverAppBar) ─
        GoRoute(
          path: '/detail/:id',
          builder: (context, state) =>
              DetailScreen(petroId: state.pathParameters['id']!),
        ),

        // ── Área administrativa ────────────────
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
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

// ─────────────────────────────────────────────
// Shell con barra de navegación inferior (visor público)
// ─────────────────────────────────────────────

class _PublicShell extends StatelessWidget {
  final Widget child;

  const _PublicShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final int currentIndex = location.startsWith('/catalog') ? 1 : 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF2D5A27).withOpacity(0.12),
        onDestinationSelected: (i) {
          if (i == 0) context.go('/');
          if (i == 1) context.go('/catalog');
          if (i == 2) context.push('/login');
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFF2D5A27)),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view, color: Color(0xFF2D5A27)),
            label: 'Catálogo',
          ),
          NavigationDestination(
            icon: Icon(Icons.manage_accounts_outlined),
            selectedIcon:
                Icon(Icons.manage_accounts, color: Color(0xFF2D5A27)),
            label: 'Administrar',
          ),
        ],
      ),
    );
  }
}
