import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OcorrenciasPainel extends StatelessWidget {
  final ScrollController scrollController;

  const OcorrenciasPainel({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE5E5E5), // Fundo cinza claro do Figma
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Linha de arrastar (Indicator)
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Conteúdo rolável
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // CARD 1: Resumo Superior
                _buildResumoCard(),
                const SizedBox(height: 16),

                // CARD 2: Gráfico Estatístico
                _buildGraficoCard(),
                const SizedBox(height: 16),

                // LISTA: Histórico Mensal
                _buildSeccaoMes("Março 2026"),
                _buildOcorrenciaItem(Icons.gavel, "Homicídio", "1 caso", "Alto", AppColors.danger),
                _buildOcorrenciaItem(Icons.directions_car, "Acidente de Trânsito", "1 caso", "Baixo", AppColors.primary),
                
                const SizedBox(height: 16),
                _buildSeccaoMes("Fevereiro 2026"),
                _buildOcorrenciaItem(Icons.directions_car, "Acidente de Trânsito", "1 caso", "Baixo", AppColors.primary),
                _buildOcorrenciaItem(Icons.front_hand, "Sequestro", "1 caso", "Médio", AppColors.warning),
                _buildOcorrenciaItem(Icons.gavel, "Homicídio", "1 caso", "Alto", AppColors.danger),
                
                const SizedBox(height: 120), // Um espaçamento extra no fundo para não bater na BottomNav
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, size: 40, color: AppColors.textDark),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: '04 ', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold, fontSize: 18)),
                      TextSpan(text: 'Ocorrências', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
                const Text('Raio de 2km', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Mais comum: Roubo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Médio', style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGraficoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [Colors.grey, AppColors.warning, Colors.orange, AppColors.danger, Colors.grey],
                stops: [0.0, 0.25, 0.5, 0.75, 1.0],
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                _buildLegendaItem(Colors.grey, "Vandalismo"),
                _buildLegendaItem(AppColors.warning, "Roubo"),
                _buildLegendaItem(Colors.orange, "Acidente Trânsito"),
                _buildLegendaItem(AppColors.danger, "Agressão"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLegendaItem(Color cor, String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(width: 16, height: 16, decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(4))),
              const SizedBox(width: 8),
              Text(texto, style: const TextStyle(fontSize: 13)),
            ],
          ),
          const Text("1", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSeccaoMes(String mes) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.calendar_month, size: 16, color: AppColors.textDark),
          const SizedBox(width: 6),
          Text(mes, style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildOcorrenciaItem(IconData icone, String titulo, String subtitulo, String tagText, Color tagColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icone, size: 28, color: AppColors.textDark),
          const SizedBox(width: 12),
          Container(width: 3, height: 30, color: tagColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitulo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: tagColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(tagText, style: TextStyle(color: tagColor, fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}