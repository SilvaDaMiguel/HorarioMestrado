class Periodo {
  final int id;
  final String diaSemana;
  final String horaInicio; // Formato "HH:MM"
  final String horaFim; // Formato "HH:MM"

  Periodo({
    required this.id,
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFim,
  });

  factory Periodo.fromMap(Map<String, dynamic> map) => Periodo(
    id: map['id'],
    diaSemana: map['diaSemana'],
    horaInicio: map['horaInicio'],
    horaFim: map['horaFim'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'diaSemana': diaSemana,
    'horaInicio': horaInicio,
    'horaFim': horaFim,
  };

}