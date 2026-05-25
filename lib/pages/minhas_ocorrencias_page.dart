import 'package:flutter/material.dart';
import '../models/ocorrencia.dart';
import '../mocks/ocorrencias_mock.dart';
import '../theme/app_colors.dart';
import '../widgets/ocorrencia_card.dart';
import '../widgets/confirm_delete_dialog.dart';

// StatefulWidget porque a lista de ocorrências muda
class MinhasOcorrenciasPage extends StatefulWidget {
  const MinhasOcorrenciasPage({super.key});

  @override
  State<MinhasOcorrenciasPage> createState() => _MinhasOcorrenciasPageState();
}

class _MinhasOcorrenciasPageState extends State<MinhasOcorrenciasPage> {
  // Cópia da lista mock pra não mexer no original
  late List<Ocorrencia> _ocorrencias = List.of(ocorrenciasMock);

  static const _meses = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];

  // Agrupa as ocorrências num Map { "Fevereiro 2026": [...], "Março 2026": [...] }
  Map<String, List<Ocorrencia>> _agruparPorMes(List<Ocorrencia> lista) {
    // Cria cópia e ordena por data (mais antigas primeiro)
    final ordenadas = [...lista]..sort((a, b) => a.data.compareTo(b.data));

    final Map<String, List<Ocorrencia>> grupos = {};
    for (final o in ordenadas) {
      // Monta a chave do grupo
      final chave = '${_meses[o.data.month - 1]} ${o.data.year}';
      // Se a chave não existe, cria lista vazia; depois adiciona a ocorrência
      grupos.putIfAbsent(chave, () => []).add(o);
    }
    return grupos;
  }

  // Disparado pelo botão lixeira do card
  Future<void> _excluir(Ocorrencia o) async {
    // Espera o usuário responder o modal
    final confirmou = await showConfirmDeleteDialog(context);
    if (confirmou == true) {
      // setState avisa o Flutter pra redesenhar a tela
      setState(() => _ocorrencias.removeWhere((x) => x.id == o.id));
    }
  }

  // Disparado pelo botão editar do card
  void _editar(Ocorrencia o) {
    // TODO: trocar pelo Navigator.push quando a tela de edição existir
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Editar ocorrência: ${o.tipo.label}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Agrupa a cada redesenho
    final grupos = _agruparPorMes(_ocorrencias);
    // Total formatado com zero à esquerda (6 -> "06")
    final total = _ocorrencias.length.toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // estica largura
        children: [
          // Card branco no topo com o contador
          _ContadorCard(total: total),

          const SizedBox(height: 12),

          // Expanded faz a lista ocupar todo espaço sobrando
          Expanded(
            // Se lista vazia, mostra empty state; senão, mostra a lista
            child: _ocorrencias.isEmpty
                ? const _EmptyState()
                : Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        // Loop pelos grupos (meses)
                        for (final entrada in grupos.entries) ...[
                          // Cabeçalho do mês
                          _CabecalhoMes(titulo: entrada.key),
                          const SizedBox(height: 8),
                          // Loop pelas ocorrências daquele mês
                          for (final o in entrada.value)
                            OcorrenciaCard(
                              ocorrencia: o,
                              // Closures capturam a ocorrência atual
                              onEdit: () => _editar(o),
                              onDelete: () => _excluir(o),
                            ),
                          const SizedBox(height: 6),
                        ],
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// Card do contador
class _ContadorCard extends StatelessWidget {
  final String total;
  const _ContadorCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.textDark, width: 1),
      ),
      child: Row(
        children: [
          // Ícone de prancheta
          const Icon(Icons.assignment_outlined,
              color: AppColors.textDark, size: 22),
          const SizedBox(width: 10),
          // Texto "Suas Ocorrências:" empurra o número pra direita
          const Expanded(
            child: Text(
              'Suas Ocorrências:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textDark,
              ),
            ),
          ),
          // Número em vermelho
          Text(
            total,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.danger,
            ),
          ),
        ],
      ),
    );
  }
}

// Cabeçalho de cada mês
class _CabecalhoMes extends StatelessWidget {
  final String titulo;
  const _CabecalhoMes({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.calendar_today_outlined,
            size: 16, color: AppColors.textDark),
        const SizedBox(width: 6),
        Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

// Tela vazia quando exclui todas ocorrencias
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.inbox_outlined, size: 60, color: AppColors.textDark),
          SizedBox(height: 12),
          Text(
            'Você ainda não registrou\nnenhuma ocorrência.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textDark),
          ),
        ],
      ),
    );
  }
}