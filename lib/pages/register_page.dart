import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/primary_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
              // Logo Centralizada
              Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                      children: [
                        TextSpan(text: 'Safe', style: TextStyle(color: Color(0xFF78BE4D))),
                        TextSpan(text: 'Zone', style: TextStyle(color: Colors.black)),
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
              const CustomInput(hintText: 'Insira seu Nome'),
              const SizedBox(height: 16),
              const CustomInput(hintText: 'Insira seu E-mail'),
              const SizedBox(height: 16),
              const CustomDropdown(
                hintText: 'Selecione seu Gênero',
                items: ['Masculino', 'Feminino', 'Outro'],
              ),
              const SizedBox(height: 16),
              const CustomInput(hintText: 'Insira sua Senha', isPassword: true),
              const SizedBox(height: 16),
              const CustomInput(hintText: 'Confirme sua Senha', isPassword: true),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Criar Conta',
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}