class Horario {
  final int horarioID;
  final int cadeiraID;
  final int periodoID;
  final int ano;
  final int semestre;
  final String data;
  final String sala;

  Horario({
    required this.horarioID,
    required this.cadeiraID,
    required this.periodoID,
    required this.ano,
    required this.semestre,
    required this.data,
    required this.sala,
  });

  factory Horario.fromMap(Map<String, dynamic> map) => Horario(
    horarioID: map['horarioID'],
    cadeiraID: map['cadeiraID'],
    periodoID: map['periodoID'],
    ano: map['ano'],
    semestre: map['semestre'],
    data: map['data'],
    sala: map['sala'],
  );

  Map<String, dynamic> toMap() => {
    'horarioID': horarioID,
    'cadeiraID': cadeiraID,
    'periodoID': periodoID,
    'ano': ano,
    'semestre': semestre,
    'data': data,
    'sala': sala,
  };
}
