import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme.dart';
import 'services/database_service.dart';
import 'screens/public/home_screen.dart';
import 'screens/public/catalog_screen.dart';
import 'screens/public/detail_screen.dart';
import 'screens/admin/login_screen.dart';
import 'screens/admin/dashboard_screen.dart';
import 'screens/admin/reportes_screen.dart';
import 'screens/admin/sitios_screen.dart';
import 'screens/admin/usuarios_screen.dart';
import 'screens/admin/petroglifo_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.init(); // ← Inicializa Hive
  runApp(const PetroglifosMauleApp());
}

class PetroglifosMauleApp extends StatelessWidget {
  const PetroglifosMauleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [

        // ══════════════════════════════════════
        // VISOR PÚBLICO — con NavigationBar inferior
        // ══════════════════════════════════════
        ShellRoute(
          builder: (context, state, child) => _PublicShell(child: child),
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

        // Detalle fuera del shell (usa SliverAppBar propio)
        GoRoute(
          path: '/detail/:id',
          builder: (context, state) =>
              DetailScreen(petroId: state.pathParameters['id']!),
        ),

        // ══════════════════════════════════════
        // ÁREA ADMINISTRATIVA
        // ══════════════════════════════════════
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/reportes',
          builder: (context, state) => const ReportesScreen(),
        ),
        GoRoute(
          path: '/sitios',
          builder: (context, state) => const SitiosScreen(),
        ),
        GoRoute(
          path: '/usuarios',
          builder: (context, state) => const UsuariosScreen(),
        ),
        GoRoute(
          path: '/nueva-ficha',
          builder: (context, state) => const PetroglifoForm(),
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

// ══════════════════════════════════════════════
// Shell del visor público con NavigationBar inferior
// ══════════════════════════════════════════════

class _PublicShell extends StatelessWidget {
  final Widget child;

  const _PublicShell({required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final int idx = location.startsWith('/catalog') ? 1 : 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        indicatorColor: const Color(0xFF2D5A27).withOpacity(0.12),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
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
