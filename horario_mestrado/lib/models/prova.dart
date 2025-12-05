class Prova{
  final int provaID;
  final int cadeiraID;
  final String sala;
  final String data; // Formato "DD-MM-YYYY"
  final String horaInicio; // Formato "HH:MM"
  final String horaFim; // Formato "HH:MM"
  final String tipo;
  final String epoca;
  final String informacao;
  final double? nota;
  final bool concluido; // Bool, 0 ou 1

  Prova({
    required this.provaID,
    required this.cadeiraID,
    this.sala = '?',
    required this.data,
    required this.horaInicio,
    required this.horaFim,
    required this.tipo,
    required this.epoca,
    this.informacao = 'Sem Informação',
    this.nota,
    required this.concluido,
  });

  factory Prova.fromMap(Map<String, dynamic> map) => Prova(
    provaID: map['provaID'],
    cadeiraID: map['cadeiraID'],
    sala: map['sala'],
    data: map['data'],
    horaInicio: map['horaInicio'],
    horaFim: map['horaFim'],
    tipo: map['tipo'],
    epoca: map['epoca'],
    informacao: map['informacao'] ?? 'em Informação',
    nota: map['nota'] != null ? map['nota'] as double : null,
    concluido: (map['concluido'] ?? 0) == 1, //Converte para bool
  );

  Map<String, dynamic> toMap() => {
    'provaID': provaID,
    'cadeiraID': cadeiraID,
    'sala': sala,
    'data': data,
    'horaInicio': horaInicio,
    'horaFim': horaFim,
    'tipo': tipo,
    'epoca': epoca,
    'informacao': informacao,
    'nota': nota,
    'concluido': concluido ? 1 : 0,
  };
}