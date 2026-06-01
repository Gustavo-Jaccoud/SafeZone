import 'dart:ffi';

import 'package:SafeZone/theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 1. IMPORTAÇÃO DO FIREBASE

// Tipos possíveis de ocorrência (lista fechada) - Permanece igual
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
      case TipoOcorrencia.vandalismo: return 'Vandalismo';
      case TipoOcorrencia.agressao: return 'Agressão';
      case TipoOcorrencia.abusoSexual: return 'Abuso sexual';
      case TipoOcorrencia.ameaca: return 'Ameaça';
      case TipoOcorrencia.homicidio: return 'Homicídio';
      case TipoOcorrencia.roubo: return 'Roubo';
      case TipoOcorrencia.sequestro: return 'Sequestro';
      case TipoOcorrencia.acidenteTransito: return 'Acidente de trânsito';
    }
  }

  Color get color {
    switch (this) {
      case TipoOcorrencia.vandalismo: return const Color(0xFF5F30CC);
      case TipoOcorrencia.agressao: return const Color(0xFFCC3030);
      case TipoOcorrencia.abusoSexual: return const Color(0xFFF56BE7);
      case TipoOcorrencia.ameaca: return const Color(0xFF606060);
      case TipoOcorrencia.homicidio: return const Color(0xFFAC2929);
      case TipoOcorrencia.roubo: return const Color(0xFFF6AE2D);
      case TipoOcorrencia.sequestro: return const Color(0xFF000000);
      case TipoOcorrencia.acidenteTransito: return const Color(0xFFF6812D);
    }
  }

  Widget get iconAsset {
    switch (this) {
      case TipoOcorrencia.vandalismo: return AppIcons.vandalismo;
      case TipoOcorrencia.agressao: return AppIcons.agressao;
      case TipoOcorrencia.abusoSexual: return AppIcons.abusoSexual;
      case TipoOcorrencia.ameaca: return AppIcons.ameaca;
      case TipoOcorrencia.homicidio: return AppIcons.homicidio;
      case TipoOcorrencia.roubo: return AppIcons.roubo;
      case TipoOcorrencia.sequestro: return AppIcons.sequestro;
      case TipoOcorrencia.acidenteTransito: return AppIcons.acidenteTransito;
    }
  }
  int get risk {
    switch (this) {
      case TipoOcorrencia.vandalismo: return 3;
      case TipoOcorrencia.ameaca: return 4;
      case TipoOcorrencia.acidenteTransito: return 5;
      case TipoOcorrencia.agressao: return 7;
      case TipoOcorrencia.roubo: return 8;
      case TipoOcorrencia.abusoSexual: return 9;
      case TipoOcorrencia.sequestro: return 10;
      case TipoOcorrencia.homicidio: return 10;
    }
  }
}

// Modelo que representa uma ocorrência atualizado para o Firebase
class Ocorrencia {
  final String? id; // 2. Tornou-se opcional (? ) porque o Firebase gera o ID depois
  final TipoOcorrencia tipo;
  final String endereco;
  final DateTime data;
  final String descricao;
  final double latitude;
  final double longitude;

  Ocorrencia({
    this.id, // Sem 'required' no ID
    required this.tipo,
    required this.endereco,
    required this.data,
    required this.descricao,
    required this.latitude,
    required this.longitude
  });

  // 4. Mudamos de 'fromJson' para 'fromFirestore' para mapear o Documento do Firebase de forma correta
  factory Ocorrencia.fromFirestore(DocumentSnapshot doc) {
    final json = doc.data() as Map<String, dynamic>;
    
    return Ocorrencia(
      id: doc.id, // O ID é pego diretamente do documento do Firebase
      tipo: TipoOcorrencia.values.firstWhere(
        (t) => t.name == json['tipo'],
        orElse: () => TipoOcorrencia.vandalismo,
      ),
      endereco: json['endereco'] as String,
      // Convertendo o Timestamp do Firebase de volta para o DateTime do Dart:
      data: (json['data'] as Timestamp).toDate(),
      descricao: json['descricao'] as String,
      // Buscando a propriedade GeoPoint:
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double
    );
  }

  // 5. Mudamos para 'toFirestore' para salvar no padrão do Firebase
  Map<String, dynamic> toFirestore() {
    return {
      // Normalmente não salvamos o ID dentro do documento, pois ele já é o nome do documento
      'tipo': tipo.name,
      'endereco': endereco,
      // Convertendo o DateTime do Dart para o Timestamp do Firebase:
      'data': Timestamp.fromDate(data),
      'descricao': descricao,
      'latitude': latitude, 
      'longitude': longitude
    };
  }

  Map<String, dynamic> toGeoJson() {
    return {
      "type": "Feature",
      "properties": {
        "id": id, 
        "tipo": tipo.name,
        "risk": tipo.risk, 
      },
      "geometry": {
        "type": "Point",
        "coordinates": [
          longitude, 
          latitude,  
        ]
      }
    };
  }
}