class Aula {
  final int aulaID;
  final int cadeiraID;
  final int periodoID;
  final String data;
  final String sala;

  Aula({
    required this.aulaID,
    required this.cadeiraID,
    required this.periodoID,
    required this.data,
    required this.sala,
  });

  factory Aula.fromMap(Map<String, dynamic> map) => Aula(
    aulaID: map['aulaID'],
    cadeiraID: map['cadeiraID'],
    periodoID: map['periodoID'],
    data: map['data'],
    sala: map['sala'],
  );

  Map<String, dynamic> toMap() => {
    'aulaID': aulaID,
    'cadeiraID': cadeiraID,
    'periodoID': periodoID,
    'data': data,
    'sala': sala,
  };
}
