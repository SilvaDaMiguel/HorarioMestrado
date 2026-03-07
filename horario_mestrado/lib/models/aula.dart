class Aula {
  final int id;
  final int cadeiraId;
  final int periodoId;
  final String data;
  final String sala;

  Aula({
    required this.id,
    required this.cadeiraId,
    required this.periodoId,
    required this.data,
    required this.sala,
  });

  factory Aula.fromMap(Map<String, dynamic> map) => Aula(
    id: map['id'],
    cadeiraId: map['cadeiraId'],
    periodoId: map['periodoId'],
    sala: map['sala'],
    data: map['data'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'cadeiraId': cadeiraId,
    'periodoId': periodoId,
    'sala': sala,
    'data': data,
  };
}
