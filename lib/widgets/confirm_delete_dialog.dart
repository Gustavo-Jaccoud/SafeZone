import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// Retorna true se o usuário clicou Sim, false ou null caso contrário
Future<bool?> showConfirmDeleteDialog(BuildContext context) {
  // showDialog abre card flutuante por cima da tela
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black54,
    builder: (ctx) {
      // modal padrão do Flutter
      return Dialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          // coluna empilha os elementos verticalmente
          child: Column(
            mainAxisSize: MainAxisSize.min, // só altura necessária
            children: [
              // icone de aviso amarelo no topo
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warning,
                size: 56,
              ),
              const SizedBox(height: 12),
              const Text(
                'Deseja Excluir essa ocorrência?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              // Linha com os dois botões
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // botão
                  OutlinedButton(
                    // pop(false) fecha o modal e retorna false
                    onPressed: () => Navigator.of(ctx).pop(false),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.danger),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Não',
                      style: TextStyle(
                        color: AppColors.danger,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // botão sim
                  ElevatedButton(
                    // pop(true) fecha o modal e retorna true
                    onPressed: () => Navigator.of(ctx).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 8,
                      ),
                      elevation: 0, // sem sombra
                    ),
                    child: const Text(
                      'Sim',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}