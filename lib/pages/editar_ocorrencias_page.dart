import 'package:SafeZone/theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SafeZone/theme/app_colors.dart';
import 'package:SafeZone/models/ocorrencia.dart';
import 'package:SafeZone/services/location_service.dart';
import 'package:SafeZone/widgets/custom_app_bar.dart';
import 'package:SafeZone/mocks/ocorrencias_mock.dart';

class EditarOcorrenciaPage extends StatefulWidget {
  final Ocorrencia ocorrencia;

  const EditarOcorrenciaPage({super.key, required this.ocorrencia});

  @override
  State<EditarOcorrenciaPage> createState() => _EditarOcorrenciaPageState();
}

class _EditarOcorrenciaPageState extends State<EditarOcorrenciaPage> {
  final _formKey = GlobalKey<FormState>();
  final _locationService = LocationService();

  TipoOcorrencia? _tipoSelecionado;
  late final TextEditingController _dataController;
  late final TextEditingController _enderecoController;
  late final TextEditingController _descricaoController;

  double? _latitude;
  double? _longitude;
  bool _loadingLocation = false;
  static const Color _fieldFill = Color(0xFFEFF8E8);

  @override
  void initState() {
    super.initState();

    _tipoSelecionado = widget.ocorrencia.tipo;
    _latitude = widget.ocorrencia.latitude;
    _longitude = widget.ocorrencia.longitude;

    // Formata a data existente para dd/mm/aaaa
    final data = widget.ocorrencia.data;
    final dataFormatada =
        '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';

    _dataController = TextEditingController(text: dataFormatada);
    _enderecoController = TextEditingController(text: widget.ocorrencia.endereco);
    _descricaoController = TextEditingController(
      text: widget.ocorrencia.descricao ?? '',
    );
  }

  @override
  void dispose() {
    _dataController.dispose();
    _enderecoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  /// Método para capturar localização via GPS
  Future<void> _capturarLocalizacaoManual() async {
    setState(() => _loadingLocation = true);

    try {
      final position = await _locationService.getCurrentLocation();
      if (position == null) return;

      _latitude = position.latitude;
      _longitude = position.longitude;
      await _locationService.saveCache(_latitude!, _longitude!);

      final placemark = await _locationService.getPlaceFromCoords(
        _latitude!,
        _longitude!,
      );

      if (placemark != null && mounted) {
        final endereco = (placemark.subLocality?.isNotEmpty ?? false)
            ? placemark.subLocality!
            : (placemark.locality ?? '');

        setState(() {
          _enderecoController.text = endereco;
        });
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  /// Exibe o calendário iniciando na data original da ocorrência
  Future<void> _pickDate() async {
    final hoje = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.ocorrencia.data,
      firstDate: DateTime(2000),
      lastDate: hoje,
    );
    if (picked != null) {
      setState(() {
        _dataController.text =
            '${picked.day.toString().padLeft(2, '0')}/'
            '${picked.month.toString().padLeft(2, '0')}/'
            '${picked.year}';
      });
    }
  }

  void _salvarAlteracoes() {
    if (!_formKey.currentState!.validate()) return;

    // Converte o texto dd/mm/aaaa de volta para DateTime
    final partesData = _dataController.text.split('/');
    final dataConvertida = DateTime(
      int.parse(partesData[2]),
      int.parse(partesData[1]),
      int.parse(partesData[0]),
    );

    final ocorrenciaAtualizada = Ocorrencia(
      id: widget.ocorrencia.id,
      tipo: _tipoSelecionado!,
      endereco: _enderecoController.text.trim(),
      data: dataConvertida,
      descricao: _descricaoController.text.trim(),
      latitude : _latitude ?? widget.ocorrencia.latitude,
      longitude: _longitude ?? widget.ocorrencia.longitude,
    );

    // Substitui diretamente na nossa lista Mock global
    final index = ocorrenciasMock.indexWhere(
      (o) => o.id == widget.ocorrencia.id,
    );
    if (index != -1) {
      ocorrenciasMock[index] = ocorrenciaAtualizada;
    }

    // Fecha a tela retornando 'true' para sinalizar que houve modificação
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        showBackButton: true,
      ), // AppBar com botão de voltar ativo
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryDark, width: 2),
                  ),
                  child: AppIcons.editarOcorrencia,
                ),
              ),
              const SizedBox(height: 28),

              _buildLabel('Tipo de Ocorrência'),
              const SizedBox(height: 8),
              _buildDropdown(),
              const SizedBox(height: 20),

              _buildLabel('Data'),
              const SizedBox(height: 8),
              _buildDateField(),
              const SizedBox(height: 20),

              _buildLabel('Localização (endereco)'),
              const SizedBox(height: 8),
              _buildLocationField(),
              const SizedBox(height: 20),

              _buildLabel('Descrição'),
              const SizedBox(height: 8),
              _buildDescriptionField(),
              const SizedBox(height: 36),

              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<TipoOcorrencia>(
      value: _tipoSelecionado,
      items: TipoOcorrencia.values
          .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
          .toList(),
      onChanged: (v) => setState(() => _tipoSelecionado = v),
      validator: (v) => v == null ? 'Selecione um tipo' : null,
      decoration: _inputDecoration(),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dataController,
      readOnly: true,
      onTap: _pickDate,
      decoration: _inputDecoration(hint: 'dd/mm/aaaa'),
    );
  }

  Widget _buildLocationField() {
    return TextFormField(
      controller: _enderecoController,
      validator: (v) =>
          (v == null || v.isEmpty) ? 'Informe a localização' : null,
      decoration: _inputDecoration(hint: 'Ex: Farolândia').copyWith(
        // Adiciona o botão de GPS apenas como um facilitador manual secundário
        suffixIcon: _loadingLocation
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.my_location, color: AppColors.primary),
                onPressed: _capturarLocalizacaoManual,
                tooltip: 'Atualizar com a localização atual do GPS',
              ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descricaoController,
      maxLines: 4,
      validator: (v) => (v == null || v.isEmpty) ? 'Descreva o ocorrido' : null,
      decoration: _inputDecoration(hint: 'Detalhes da ocorrência...'),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _salvarAlteracoes,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Editar Ocorrência',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    const radius = BorderRadius.all(Radius.circular(28));
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: _fieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      border: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: AppColors.primaryHover, width: 2),
      ),
    );
  }
}
