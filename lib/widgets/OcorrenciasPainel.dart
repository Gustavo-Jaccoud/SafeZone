import 'package:SafeZone/models/ocorrencia.dart';
import 'package:SafeZone/theme/app_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';

class OcorrenciasPainel extends StatelessWidget {
  final ScrollController scrollController;

  const OcorrenciasPainel({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(200, 241, 241, 241), 
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
                _buildOcorrenciaItem(TipoOcorrencia.homicidio, "1 caso", "Alto", AppColors.danger),
                _buildOcorrenciaItem(TipoOcorrencia.acidenteTransito, "1 caso", "Baixo", AppColors.primary),
                
                const SizedBox(height: 16),
                _buildSeccaoMes("Fevereiro 2026"),
                _buildOcorrenciaItem(TipoOcorrencia.acidenteTransito, "1 caso", "Baixo", AppColors.primary),
                _buildOcorrenciaItem(TipoOcorrencia.sequestro, "1 caso", "Médio", AppColors.warning),
                _buildOcorrenciaItem(TipoOcorrencia.homicidio, "1 caso", "Alto", AppColors.danger),
                
                const SizedBox(height: 120),
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
          AppIcons.boletim_ocorrencia,
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
        SizedBox(
          width: 120,
          height: 120,
          child: PieChart(
            PieChartData(
              sectionsSpace: 1,
              centerSpaceRadius: 0, // 0 = pizza cheia
              borderData: FlBorderData(show: false),
              sections: [
                PieChartSectionData(
                  value: 1,
                  color: TipoOcorrencia.vandalismo.color,
                  title: '',
                  radius: 60,
                ),
                PieChartSectionData(
                  value: 1,
                  color: TipoOcorrencia.roubo.color,
                  title: '',
                  radius: 60,
                ),
                PieChartSectionData(
                  value: 1,
                  color: TipoOcorrencia.acidenteTransito.color,
                  title: '',
                  radius: 60,
                ),
                PieChartSectionData(
                  value: 1,
                  color: TipoOcorrencia.agressao.color,
                  title: '',
                  radius: 60,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 20),

        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendaItem(TipoOcorrencia.vandalismo),
              _buildLegendaItem(TipoOcorrencia.roubo),
              _buildLegendaItem(TipoOcorrencia.acidenteTransito),
              _buildLegendaItem(TipoOcorrencia.agressao),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildLegendaItem(TipoOcorrencia tipo) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: tipo.color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              tipo.label,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
        const Text(
          "1",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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

  Widget _buildOcorrenciaItem(TipoOcorrencia tipo, String subtitulo, String tagText, Color tagColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          tipo.iconAsset,
          const SizedBox(width: 12),
          Container(width: 3, height: 30, color: tipo.color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tipo.label, style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 14)),
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