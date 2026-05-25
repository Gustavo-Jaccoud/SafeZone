// Tipos possíveis de ocorrência (lista fechada)
import 'package:SafeZone/theme/app_icons.dart';
import 'package:flutter/material.dart';

enum TipoOcorrencia {
  vandalismo,
  agressao,
  abusoSexual,
  ameaca,
  homicidio,
  roubo,
  sequestro,
  acidenteTransito,
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
      case TipoOcorrencia.ameaca:
        return 'Ameaça';
      case TipoOcorrencia.homicidio:
        return 'Homicídio';
      case TipoOcorrencia.roubo:
        return 'Roubo';
      case TipoOcorrencia.sequestro:
        return 'Sequestro';
      case TipoOcorrencia.acidenteTransito:
        return 'Acidente de trânsito';
    }
  }

  Color get color {
    switch (this) {
      case TipoOcorrencia.vandalismo:
        return const Color(0xFF5F30CC);
      case TipoOcorrencia.agressao:
        return const Color(0xFFCC3030);
      case TipoOcorrencia.abusoSexual:
        return const Color(0xFFF56BE7);
      case TipoOcorrencia.ameaca:
        return const Color(0xFF606060);
      case TipoOcorrencia.homicidio:
        return const Color(0xFFAC2929);
      case TipoOcorrencia.roubo:
        return const Color(0xFFF6AE2D);
      case TipoOcorrencia.sequestro:
        return const Color(0xFF000000);
      case TipoOcorrencia.acidenteTransito:
        return const Color(0xFFF6812D);
    }
  }

  Widget get iconAsset {
    switch (this) {
      case TipoOcorrencia.vandalismo:
        return AppIcons.vandalismo;
      case TipoOcorrencia.agressao:
        return AppIcons.agressao;
      case TipoOcorrencia.abusoSexual:
        return AppIcons.abusoSexual;
      case TipoOcorrencia.ameaca:
        return AppIcons.ameaca;
      case TipoOcorrencia.homicidio:
        return AppIcons.homicidio;
      case TipoOcorrencia.roubo:
        return AppIcons.roubo;
      case TipoOcorrencia.sequestro:
        return AppIcons.sequestro;
      case TipoOcorrencia.acidenteTransito:
        return AppIcons.acidenteTransito;
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