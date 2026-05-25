import '../models/ocorrencia.dart';

// Lista de ocorrências fake pra preencher a tela enquanto não tem backend
final List<Ocorrencia> ocorrenciasMock = [
  Ocorrencia(
    id: '1',
    tipo: TipoOcorrencia.vandalismo,
    bairro: 'Aracaju',
    data: DateTime(2026, 2, 28), 
    descricao: 'Pichação no muro da escola.',
  ),
  Ocorrencia(
    id: '2',
    tipo: TipoOcorrencia.agressao,
    bairro: 'Aracaju',
    data: DateTime(2026, 2, 19),
    descricao: 'Discussão de trânsito violenta.',
  ),
  Ocorrencia(
    id: '3',
    tipo: TipoOcorrencia.abusoSexual,
    bairro: 'Aracaju',
    data: DateTime(2026, 2, 17),
    descricao: 'Assédio verbal no transporte público.',
  ),
  Ocorrencia(
    id: '4',
    tipo: TipoOcorrencia.vandalismo,
    bairro: 'Aracaju',
    data: DateTime(2026, 3, 27),
    descricao: 'Lixeiras destruídas na praça.',
  ),
  Ocorrencia(
    id: '5',
    tipo: TipoOcorrencia.agressao,
    bairro: 'Aracaju',
    data: DateTime(2026, 3, 14),
    descricao: 'Briga na saída do estádio.',
  ),
  Ocorrencia(
    id: '6',
    tipo: TipoOcorrencia.abusoSexual,
    bairro: 'Aracaju',
    data: DateTime(2026, 2, 7),
    descricao: 'Importunação em via pública.',
  ),
  Ocorrencia(
    id: '7',
    tipo: TipoOcorrencia.vandalismo,
    bairro: 'Aracaju',
    data: DateTime(2026, 2, 8),
    descricao: 'Vidros quebrados no ponto de ônibus.',
  ),
];