import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_input.dart';
import '../widgets/primary_button.dart';
import '../app/app_shell.dart';
import '../services/auth_service.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Preencha todos os campos.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AppShell()),
          (route) => false,
        );
      }
    } catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithGoogle();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AppShell()),
          (route) => false,
        );
      }
    } catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.danger),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Column(
                children: [
                  Image.asset('assets/images/logo.png', height: 90, fit: BoxFit.contain),
                  const SizedBox(height: 16),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                      children: [
                        TextSpan(text: 'Safe', style: TextStyle(color: AppColors.primary)),
                        TextSpan(text: 'Zone', style: TextStyle(color: AppColors.primaryDark)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Seu app de Controle de Segurança',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.primaryDark),
              ),
              const SizedBox(height: 40),
              CustomInput(hintText: 'E-mail', controller: _emailController),
              const SizedBox(height: 16),
              CustomInput(hintText: 'Senha', isPassword: true, controller: _passwordController),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
                  },
                  child: const Text('Esqueci a senha', style: TextStyle(color: Colors.black54, fontSize: 12)),
                ),
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const CircularProgressIndicator(color: AppColors.primary)
              else ...[
                PrimaryButton(text: 'Entrar', onPressed: _handleEmailLogin),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.g_mobiledata, size: 30, color: AppColors.primaryDark),
                    label: const Text('Entrar com Google', style: TextStyle(color: AppColors.primaryDark, fontSize: 16, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: _handleGoogleLogin,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Não tem uma conta? ', style: TextStyle(color: AppColors.primaryDark, fontSize: 12)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                    },
                    child: const Text('Registre-se', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}