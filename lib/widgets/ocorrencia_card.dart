import 'package:flutter/material.dart';
import '../models/ocorrencia.dart';
import '../theme/app_colors.dart';

// Card que representa uma ocorrência na lista
class OcorrenciaCard extends StatelessWidget {
  final Ocorrencia ocorrencia; // dados da ocorrencia
  // o card avisa quando o usuário clica nos botões
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OcorrenciaCard({
    super.key,
    required this.ocorrencia,
    required this.onEdit,
    required this.onDelete,
  });

  // Define a cor da borda de acordo com o tipo da ocorrência
  Color get _borderColor {
    switch (ocorrencia.tipo) {
      case TipoOcorrencia.vandalismo:
        return const Color(0xFF6C4DE0); // roxo
      case TipoOcorrencia.agressao:
        return AppColors.danger; // vermelho
      case TipoOcorrencia.abusoSexual:
        return const Color(0xFFE05A8E); // rosa
    }
  }

  // Formata a data no padrão dd/mm/aaaa
  String _formatData(DateTime d) {
    // Função auxiliar pra colocar zero à esquerda (5 -> "05")
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(d.day)}/${dois(d.month)}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), // espaço entre cards
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // cantos arredondados
        border: Border.all(color: _borderColor, width: 1.5), // borda colorida
        boxShadow: [
          // Sombra sutil pra dar profundidade
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row( //horizontal
        children: [
          // Ícone do tipo com fallback
          _IconeOcorrencia(tipo: ocorrencia.tipo),

          const SizedBox(width: 12),

          //espaço entre icone e botão
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, //alinha esquerda
              mainAxisSize: MainAxisSize.min, //altura
              children: [
                //nome do tipo em negrito
                Text(
                  ocorrencia.tipo.label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                //bairro
                Text(
                  ocorrencia.bairro,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textDark,
                  ),
                ),
                //data formatada
                Text(
                  _formatData(ocorrencia.data),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),

          // Botão editar
          IconButton(
            onPressed: onEdit, // dispara o callback
            icon: const Icon(Icons.edit, color: AppColors.primary),
            tooltip: 'Editar',
            visualDensity: VisualDensity.compact, // reduz tamanho de toque
          ),
          // Botão excluir
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, color: AppColors.danger),
            tooltip: 'Excluir',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

// mostra o ícone do tipo com fallback
class _IconeOcorrencia extends StatelessWidget {
  final TipoOcorrencia tipo;
  const _IconeOcorrencia({required this.tipo});

  // Ícone padrão caso o asset não exista
  IconData get _fallbackIcon {
    switch (tipo) {
      case TipoOcorrencia.vandalismo:
        return Icons.broken_image;
      case TipoOcorrencia.agressao:
        return Icons.front_hand;
      case TipoOcorrencia.abusoSexual:
        return Icons.report_problem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Image.asset(
        tipo.iconAsset,
        fit: BoxFit.contain,
        // se a imagem não carregar, mostra um ícone do Material
        errorBuilder: (_, __, ___) =>
            Icon(_fallbackIcon, color: AppColors.textDark, size: 28),
      ),
    );
  }
}