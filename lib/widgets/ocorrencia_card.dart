import 'package:flutter/material.dart';
import '../models/ocorrencia.dart';
import '../theme/app_colors.dart';

// Card que representa uma ocorrência na lista
class OcorrenciaCard extends StatelessWidget {
  final Ocorrencia ocorrencia;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const OcorrenciaCard({
    super.key,
    required this.ocorrencia,
    required this.onEdit,
    required this.onDelete,
  });

  // Formata a data no padrão dd/mm/aaaa
  String _formatData(DateTime d) {
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(d.day)}/${dois(d.month)}/${d.year}';
  }

  // Extrai só a cidade/bairro do endereço completo
  // Ex: "Rua X, 123, Farolândia, Aracaju" -> "Farolândia, Aracaju"
  String _resumoEndereco(String endereco) {
    final partes = endereco.split(',').map((e) => e.trim()).toList();
    if (partes.length <= 2) return endereco; // já é curto
    // Pega os dois últimos pedaços (geralmente bairro e cidade)
    return '${partes[partes.length - 2]}, ${partes.last}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // Usa a cor que já vem do model (tipo.color)
        border: Border.all(color: ocorrencia.tipo.color, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ícone do tipo (vem do model, é um Widget)
          SizedBox(width: 36, height: 36, child: ocorrencia.tipo.iconAsset),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nome do tipo
                Text(
                  ocorrencia.tipo.label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                // Cidade/bairro extraído do endereço
                Text(
                  _resumoEndereco(ocorrencia.endereco),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                ),
                // Data formatada
                Text(
                  _formatData(ocorrencia.data),
                  style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                ),
              ],
            ),
          ),

          // Botão editar
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, color: AppColors.primary),
            tooltip: 'Editar',
            visualDensity: VisualDensity.compact,
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