import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_input.dart';
import '../widgets/primary_button.dart';
import '../services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira o e-mail para recuperar a senha.'), backgroundColor: AppColors.danger),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.resetPassword(_emailController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail de recuperação enviado!'), backgroundColor: AppColors.primary),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: AppColors.danger),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Center(
                child: Column(
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
              ),
              const SizedBox(height: 50),
              const Text(
                'Esqueceu a senha?',
                style: TextStyle(color: AppColors.primaryDark, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              CustomInput(hintText: 'E-mail', controller: _emailController),
              const SizedBox(height: 32),
              if (_isLoading)
                const Center(child: CircularProgressIndicator(color: AppColors.primary))
              else
                PrimaryButton(text: 'Recuperar', onPressed: _handleReset),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Lembrou a senha? ', style: TextStyle(color: AppColors.primaryDark, fontSize: 14)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Entrar', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}