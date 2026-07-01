// login_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/database_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'felipe@patrimonio.cl');
  final _passCtrl  = TextEditingController(text: '1234');
  bool _obscure    = true;
  bool _loading    = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header verde
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 64, 24, 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A3A17), Color(0xFF2D5A27)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.landscape,
                        color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 14),
                  const Text('Petroglifos Maule',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Panel administrativo',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),

            // Formulario
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Correo institucional',
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                      ),
                      validator: (v) =>
                          (v?.isEmpty ?? true) ? 'Ingresa tu correo' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        suffixIcon: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                      ),
                      validator: (v) =>
                          (v?.isEmpty ?? true) ? 'Ingresa tu contraseña' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _loading ? null : _login,
                        icon: _loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.login),
                        label: Text(
                            _loading ? 'Verificando...' : 'Iniciar sesión'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D5A27),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Volver al visor público'),
                      style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF2D5A27)),
                    ),

                    // Hint de demo
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2E1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 16, color: Color(0xFF2D5A27)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Demo: felipe@patrimonio.cl / 1234',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFF2D5A27)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final usuario = DatabaseService.instance
        .login(_emailCtrl.text.trim(), _passCtrl.text.trim());

    if (mounted) {
      setState(() => _loading = false);
      if (usuario != null) {
        context.go('/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciales incorrectas'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
