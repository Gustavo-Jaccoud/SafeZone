// Tipos possíveis de ocorrência (lista fechada)
enum TipoOcorrencia {
  vandalismo,
  agressao,
  abusoSexual,
}

// Extension adiciona getters ao enum sem mexer na declaração
extension TipoOcorrenciaExt on TipoOcorrencia {
  String get label {
    switch (this) {
      case TipoOcorrencia.vandalismo:
        return 'Vandalismo';
      case TipoOcorrencia.agressao:
        return 'Agressão';
      case TipoOcorrencia.abusoSexual:
        return 'Abuso sexual';
    }
  }

  // Caminho da imagem do ícone de cada tipo
  String get iconAsset {
    switch (this) {
      case TipoOcorrencia.vandalismo:
        return 'assets/images/icon_vandalismo.png';
      case TipoOcorrencia.agressao:
        return 'assets/images/icon_agressao.png';
      case TipoOcorrencia.abusoSexual:
        return 'assets/images/icon_abuso_sexual.png';
    }
  }
}

// Modelo que representa uma ocorrência
class Ocorrencia {
  final String id;
  final TipoOcorrencia tipo;
  final String bairro;
  final DateTime data;

  // Construtor com campos obrigatórios
  Ocorrencia({
    required this.id,
    required this.tipo,
    required this.bairro,
    required this.data,
  });

  // Cria uma Ocorrencia a partir de um Map "JSON do backend"
  factory Ocorrencia.fromJson(Map<String, dynamic> json) {
    return Ocorrencia(
      id: json['id'] as String,
      // Busca o enum pelo nome; se não achar, usa vandalismo
      tipo: TipoOcorrencia.values.firstWhere(
        (t) => t.name == json['tipo'],
        orElse: () => TipoOcorrencia.vandalismo,
      ),
      bairro: json['bairro'] as String,
      data: DateTime.parse(json['data'] as String),
    );
  }

  // Transforma a Ocorrencia em Map (pra enviar/salvar)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo.name,
      'bairro': bairro,
      'data': data.toIso8601String(),
    };
  }
}