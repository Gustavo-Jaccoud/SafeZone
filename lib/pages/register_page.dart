import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/primary_button.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty) {
      _showError('Preencha todos os campos.');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('As senhas não coincidem.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.registerWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conta criada com sucesso! Faça login.'), backgroundColor: AppColors.primary),
        );
        Navigator.pop(context);
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
              const SizedBox(height: 40),
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
                'Lorem Ipsum is simply dummy\ntext of the printing',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.primaryDark),
              ),
              const SizedBox(height: 32),
              CustomInput(hintText: 'Insira seu Nome', controller: _nameController),
              const SizedBox(height: 16),
              CustomInput(hintText: 'Insira seu E-mail', controller: _emailController),
              const SizedBox(height: 16),
              const CustomDropdown(
                hintText: 'Selecione seu Gênero',
                items: ['Masculino', 'Feminino', 'Outro'],
              ),
              const SizedBox(height: 16),
              CustomInput(hintText: 'Insira sua Senha', isPassword: true, controller: _passwordController),
              const SizedBox(height: 16),
              CustomInput(hintText: 'Confirme sua Senha', isPassword: true, controller: _confirmPasswordController),
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator(color: AppColors.primary)
              else
                PrimaryButton(text: 'Criar Conta', onPressed: _handleRegister),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}