import '../models/ocorrencia.dart';

// Lista de ocorrências fake pra preencher a tela enquanto não tem backend
final List<Ocorrencia> ocorrenciasMock = [
  Ocorrencia(
    id: '1',
    tipo: TipoOcorrencia.vandalismo,
    bairro: 'Aracaju',
    data: DateTime(2026, 2, 30), // ano, mês, dia
    descricao: ""
  ),
  Ocorrencia(
    id: '2',
    tipo: TipoOcorrencia.agressao,
    bairro: 'Aracaju',
    data: DateTime(2026, 2, 19),
    descricao: ""
  ),
  Ocorrencia(
    id: '3',
    tipo: TipoOcorrencia.abusoSexual,
    bairro: 'Aracaju',
    data: DateTime(2026, 2, 17),
    descricao: ""
  ),
  Ocorrencia(
    id: '4',
    tipo: TipoOcorrencia.vandalismo,
    bairro: 'Aracaju',
    data: DateTime(2026, 3, 27),
    descricao: ""
  ),
  Ocorrencia(
    id: '5',
    tipo: TipoOcorrencia.agressao,
    bairro: 'Aracaju',
    data: DateTime(2026, 3, 14),
    descricao: ""
  ),
  Ocorrencia(
    id: '6',
    tipo: TipoOcorrencia.abusoSexual,
    bairro: 'Aracaju',
    data: DateTime(2026, 2, 7),
    descricao: ""
  ),
  Ocorrencia(
    id: '7',
    tipo: TipoOcorrencia.vandalismo,
    bairro: 'Aracaju',
    data: DateTime(2026, 2, 8),
    descricao: ""
  ),
];