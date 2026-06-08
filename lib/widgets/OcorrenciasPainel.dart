import 'package:SafeZone/models/ocorrencia.dart';
import 'package:SafeZone/theme/app_icons.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';

class OcorrenciasPainel extends StatelessWidget {
  final ScrollController scrollController;
  final List<Ocorrencia> ocorrencias; 

  const OcorrenciasPainel({
    super.key, 
    required this.scrollController,
    required this.ocorrencias,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(240, 241, 241, 241), 
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
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
          
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildResumoCard(),
                const SizedBox(height: 16),

                _buildGraficoCard(),
                const SizedBox(height: 16),

                _buildListaOcorrenciasReais(),
                
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoCard() {
    final totalOcorrencias = ocorrencias.length;
    
    String maisComum = 'Nenhum';
    if (ocorrencias.isNotEmpty) {
      final contagem = <TipoOcorrencia, int>{};
      for (var o in ocorrencias) {
        contagem[o.tipo] = (contagem[o.tipo] ?? 0) + 1;
      }
      maisComum = contagem.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key
          .label;
    }

    String nivelPerigoTexto = 'Nenhum';
    Color nivelPerigoCor = AppColors.primary;

    if (ocorrencias.isNotEmpty) {
      double somaRisco = 0;
      for (var o in ocorrencias) {
        somaRisco += o.tipo.risk; 
      }
      double mediaRisco = somaRisco / totalOcorrencias;

      if (mediaRisco >= 7) {
        nivelPerigoTexto = 'Alto';
        nivelPerigoCor = AppColors.danger;
      } else if (mediaRisco >= 4) {
        nivelPerigoTexto = 'Médio';
        nivelPerigoCor = AppColors.warning;
      } else {
        nivelPerigoTexto = 'Baixo';
        nivelPerigoCor = AppColors.primary;
      }
    }

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
                      // Quantidade real totalizada
                      TextSpan(
                        text: '${totalOcorrencias.toString().padLeft(2, '0')} ', 
                        style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const TextSpan(text: 'Ocorrências', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
                const Text('Raio de 10km', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Mais comum: $maisComum', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              // TAG TOTALMENTE ADAPTÁVEL:
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: nivelPerigoCor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  nivelPerigoTexto, 
                  style: TextStyle(color: nivelPerigoCor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGraficoCard() {
    if (ocorrencias.isEmpty) {
      return const SizedBox.shrink(); 
    }

    final mapaContagem = <TipoOcorrencia, int>{};
    for (var o in ocorrencias) {
      mapaContagem[o.tipo] = (mapaContagem[o.tipo] ?? 0) + 1;
    }

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
                centerSpaceRadius: 0,
                borderData: FlBorderData(show: false),
                sections: mapaContagem.entries.map((entry) {
                  return PieChartSectionData(
                    value: entry.value.toDouble(),
                    color: entry.key.color,
                    title: '',
                    radius: 60,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: mapaContagem.entries.map((entry) {
                return _buildLegendaItem(entry.key, entry.value);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendaItem(TipoOcorrencia tipo, int quantidade) {
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
              Text(tipo.label, style: const TextStyle(fontSize: 13)),
            ],
          ),
          Text(
            "$quantidade",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildListaOcorrenciasReais() {
    if (ocorrencias.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('Nenhuma ocorrência registrada por perto.', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    final listaOrdenada = List<Ocorrencia>.from(ocorrencias)
      ..sort((a, b) => b.data.compareTo(a.data));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listaOrdenada.map((ocorrencia) {
        String tagText = "Baixo";
        Color tagColor = AppColors.primary;
        
        if (ocorrencia.tipo.risk >= 7) {
          tagText = "Alto";
          tagColor = AppColors.danger;
        } else if (ocorrencia.tipo.risk >= 4) {
          tagText = "Médio";
          tagColor = AppColors.warning;
        }

        final data = ocorrencia.data;
        final dataStr = '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ocorrencia.tipo.iconAsset,
              const SizedBox(width: 12),
              Container(width: 3, height: 30, color: ocorrencia.tipo.color),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ocorrencia.tipo.label, style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('$dataStr - ${ocorrencia.endereco}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
      }).toList(),
    );
  }
}