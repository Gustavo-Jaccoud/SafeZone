import 'package:SafeZone/theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:SafeZone/theme/app_colors.dart';
import 'package:SafeZone/models/ocorrencia.dart';
import 'package:SafeZone/services/location_service.dart';
import 'package:SafeZone/widgets/custom_app_bar.dart';

class CadastrarOcorrenciaPage extends StatefulWidget {
  const CadastrarOcorrenciaPage({super.key});

  @override
  State<CadastrarOcorrenciaPage> createState() =>
      _CadastrarOcorrenciaPageState();
}

class _CadastrarOcorrenciaPageState extends State<CadastrarOcorrenciaPage> {
  final _formKey = GlobalKey<FormState>();
  final _locationService = LocationService();

  TipoOcorrencia? _tipoSelecionado;
  final _dataController = TextEditingController();
  final _bairroController = TextEditingController();
  final _descricaoController = TextEditingController();

  bool _loadingLocation = false;

  static const Color _fieldFill = Color(0xFFEFF8E8);

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  @override
  void dispose() {
    _dataController.dispose();
    _bairroController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  /// Tenta obter a localização atual do usuário via GPS para preenchimento automático do bairro.
  Future<void> _loadLocation() async {
    setState(() => _loadingLocation = true);

    try {
      final position = await _locationService.getCurrentLocation();
      if (position == null) return;

      await _locationService.saveCache(position.latitude, position.longitude);

      final placemark = await _locationService.getPlaceFromCoords(
        position.latitude,
        position.longitude,
      );

      if (placemark != null && mounted) {
        final bairro = (placemark.subLocality?.isNotEmpty ?? false)
            ? placemark.subLocality!
            : (placemark.locality ?? '');

        setState(() {
          _bairroController.text = bairro;
        });
      }
    } catch (_) {
      // Falha na obtenção da localização.
    } finally {
      if (mounted) setState(() => _loadingLocation = false);
    }
  }

  /// Exibe o calendário para seleção da data da ocorrência e atualiza o respectivo controlador.
  Future<void> _pickDate() async {
    final hoje = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: hoje,
      firstDate: DateTime(2000),
      lastDate: hoje,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
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

  /// Valida o formato e a coerência da data inserida.
  String? _validarData(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Informe a data da ocorrência';
    }

    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!regex.hasMatch(valor)) {
      return 'Use o formato dd/mm/aaaa';
    }

    final partes = valor.split('/');
    final dia = int.tryParse(partes[0]);
    final mes = int.tryParse(partes[1]);
    final ano = int.tryParse(partes[2]);

    if (dia == null || mes == null || ano == null) return 'Data inválida';
    if (mes < 1 || mes > 12) return 'Mês inválido (01–12)';
    if (dia < 1 || dia > 31) return 'Dia inválido (01–31)';

    final data = DateTime(ano, mes, dia);
    if (data.day != dia || data.month != mes || data.year != ano) {
      return 'Data inexistente';
    }

    final hoje = DateTime.now();
    final hojeOnly = DateTime(hoje.year, hoje.month, hoje.day);
    if (data.isAfter(hojeOnly)) return 'A data não pode ser futura';

    return null;
  }

  /// Executa a validação do form.
  void _cadastrar() {
    if (!_formKey.currentState!.validate()) return;

    final novaOcorrencia = Ocorrencia(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tipo: _tipoSelecionado!,
      bairro: _bairroController.text.trim(),
      data: _parseData(_dataController.text),
      descricao: _descricaoController.text.trim(),
    );

    debugPrint(novaOcorrencia.toJson().toString());
  }

  /// Converte a string formatada em dd/MM/yyyy para um objeto [DateTime].
  DateTime _parseData(String texto) {
    final partes = texto.split('/');
    return DateTime(
      int.parse(partes[2]),
      int.parse(partes[1]),
      int.parse(partes[0]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(showBackButton: true),
      body: _buildBody(),
    );
  }

  /// Constrói a estrutura principal do formulário.
  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormIcon(),
            const SizedBox(height: 28),
            _buildLabel('Tipo de Ocorrência'),
            const SizedBox(height: 8),
            _buildDropdown(),
            const SizedBox(height: 20),
            _buildLabel('Data'),
            const SizedBox(height: 8),
            _buildDateField(),
            const SizedBox(height: 20),
            _buildLabel('Localização'),
            const SizedBox(height: 8),
            _buildLocationField(),
            const SizedBox(height: 20),
            _buildLabel('Descrição'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _descricaoController,
              hint: 'Descreva o que aconteceu ...',
              maxLines: 4,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Descreva a ocorrência' : null,
            ),
            const SizedBox(height: 36),
            _buildSubmitButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFormIcon() {
    return Center(
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryDark, width: 2),
        ),
        child: AppIcons.novaOcorrencia
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
      hint: const Text(
        'Selecione o tipo',
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
      items: TipoOcorrencia.values
          .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
          .toList(),
      onChanged: (v) => setState(() => _tipoSelecionado = v),
      validator: (v) => v == null ? 'Selecione um tipo de ocorrência' : null,
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
      borderRadius: BorderRadius.circular(16),
      decoration: _inputDecoration(),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dataController,
      readOnly: true,
      onTap: _pickDate,
      validator: _validarData,
      decoration: _inputDecoration(hint: 'dd/mm/aaaa'),
    );
  }

  Widget _buildLocationField() {
    return TextFormField(
      controller: _bairroController,
      validator: (v) =>
          (v == null || v.isEmpty) ? 'Informe a localização' : null,
      decoration: _inputDecoration(hint: 'Ex: Farolândia, Aracaju-SE').copyWith(
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
                tooltip: 'Usar minha localização',
                onPressed: _loadLocation,
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: _inputDecoration(hint: hint),
    );
  }

 
  InputDecoration _inputDecoration({String? hint}) {
    const radius = BorderRadius.all(Radius.circular(28));
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: _fieldFill,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: AppColors.primaryHover, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: AppColors.danger, width: 2),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _cadastrar,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Cadastrar Ocorrência',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}