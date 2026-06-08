import 'package:SafeZone/pages/editar_ocorrencias_page.dart';
import 'package:SafeZone/theme/app_icons.dart';
import 'package:flutter/material.dart';
import '../models/ocorrencia.dart';
import '../firebase/minhas_ocorrencias_service.dart';
import '../theme/app_colors.dart';
import '../widgets/ocorrencia_card.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../services/auth_service.dart';
import '../pages/login_start_page.dart';

class MinhasOcorrenciasPage extends StatefulWidget {
  const MinhasOcorrenciasPage({super.key});

  @override
  State<MinhasOcorrenciasPage> createState() => _MinhasOcorrenciasPageState();
}

class _MinhasOcorrenciasPageState extends State<MinhasOcorrenciasPage> {
  final _service = MinhasOcorrenciasService();

  // Guarda o "future" da busca; trocar ele força o FutureBuilder a recarregar
  late Future<List<Ocorrencia>> _futureOcorrencias;

  static const _meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  // Dispara (ou redispara) a busca no Firebase
  void _carregar() {
    setState(() {
      _futureOcorrencias = _service.buscarMinhasOcorrencias();
    });
  }

  // Agrupa as ocorrências por "Mês Ano"
  Map<String, List<Ocorrencia>> _agruparPorMes(List<Ocorrencia> lista) {
    final ordenadas = [...lista]..sort((a, b) => a.data.compareTo(b.data));
    final Map<String, List<Ocorrencia>> grupos = {};
    for (final o in ordenadas) {
      final chave = '${_meses[o.data.month - 1]} ${o.data.year}';
      grupos.putIfAbsent(chave, () => []).add(o);
    }
    return grupos;
  }

  // Exclui no Firebase e recarrega a lista
  Future<void> _excluir(Ocorrencia o) async {
    final confirmou = await showConfirmDeleteDialog(context);
    if (confirmou == true && o.id != null) {
      try {
        await _service.excluirOcorrencia(o.id!);
        _carregar(); // recarrega depois de excluir
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao excluir: $e')));
      }
    }
  }

  void _editar(Ocorrencia o) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditarOcorrenciaPage(ocorrencia: o)),
    );
  }

  Future<void> _sair() async {
    await AuthService().signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginStartPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 70),
      child: FutureBuilder<List<Ocorrencia>>(
        future: _futureOcorrencias,
        builder: (context, snapshot) {
          // Estado: carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          // Estado: erro
          if (snapshot.hasError) {
            return _ErroState(
              mensagem: '${snapshot.error}',
              onTentarNovamente: _carregar,
            );
          }

          final ocorrencias = snapshot.data ?? [];
          final grupos = _agruparPorMes(ocorrencias);
          final total = ocorrencias.length.toString().padLeft(2, '0');

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: _ContadorCard(total: total)),

                  const SizedBox(width: 12),
                  SizedBox(
                    height: 55,
                    child: OutlinedButton.icon(
                      onPressed: _sair,
                      icon: const Icon(
                        Icons.logout,
                        size: 20,
                        color: AppColors.danger,
                      ),
                      label: const Text(
                        'Sair',
                        style: TextStyle(
                          color: AppColors.danger,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.danger,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ocorrencias.isEmpty
                    ? const _EmptyState()
                    : Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            for (final entrada in grupos.entries) ...[
                              _CabecalhoMes(titulo: entrada.key),
                              const SizedBox(height: 8),
                              for (final o in entrada.value)
                                OcorrenciaCard(
                                  ocorrencia: o,
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
          );
        },
      ),
    );
  }
}

class _ContadorCard extends StatelessWidget {
  final String total;
  const _ContadorCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.textDark, width: 1),
      ),
      child: Row(
        children: [
          AppIcons.boletim_ocorrencia,
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Suas Ocorrências:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textDark,
              ),
            ),
          ),
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

class _CabecalhoMes extends StatelessWidget {
  final String titulo;
  const _CabecalhoMes({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.calendar_month, size: 16, color: AppColors.textDark),
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

// Estado de erro com botão de tentar novamente
class _ErroState extends StatelessWidget {
  final String mensagem;
  final VoidCallback onTentarNovamente;
  const _ErroState({required this.mensagem, required this.onTentarNovamente});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 60, color: AppColors.danger),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              mensagem,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textDark),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTentarNovamente,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text(
              'Tentar novamente',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
