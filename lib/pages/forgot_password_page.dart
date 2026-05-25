import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_input.dart';
import '../widgets/primary_button.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

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
              ),
              const SizedBox(height: 50),
              const Text(
                'Esqueceu a senha?',
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const CustomInput(hintText: 'E-mail'),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Recuperar',
                onPressed: () {},
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Lembrou a senha? ',
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
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