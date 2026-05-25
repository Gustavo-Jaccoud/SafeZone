// Tipos possíveis de ocorrência 
enum TipoOcorrencia {
  vandalismo,
  agressao,
  abusoSexual,
}


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


class Ocorrencia {
  final String id;
  final TipoOcorrencia tipo;
  final String bairro;
  final DateTime data;
  final String descricao;

  
  Ocorrencia({
    required this.id,
    required this.tipo,
    required this.bairro,
    required this.data,
    required this.descricao,
  });

  
  factory Ocorrencia.fromJson(Map<String, dynamic> json) {
    return Ocorrencia(
      id: json['id'] as String,
      
      tipo: TipoOcorrencia.values.firstWhere(
        (t) => t.name == json['tipo'],
        orElse: () => TipoOcorrencia.vandalismo,
      ),
      bairro: json['bairro'] as String,
      data: DateTime.parse(json['data'] as String),
      descricao: json['descricao'] as String,
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo.name,
      'bairro': bairro,
      'data': data.toIso8601String(),
      'descricao': descricao,
    };
  }
}