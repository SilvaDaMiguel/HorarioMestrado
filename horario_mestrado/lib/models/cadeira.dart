class Cadeira {
  final int cadeiraID;
  final String nome;
  final String sigla;

  Cadeira({
    required this.cadeiraID,
    required this.nome,
    required this.sigla,
  });

  factory Cadeira.fromMap(Map<String, dynamic> map) => Cadeira(
    cadeiraID: map['cadeiraID'],
    nome: map['nome'] ?? "Nome Não Definido",
    sigla: map['sigla'] ?? "Sigla Não Definida",
  );

  Map<String, dynamic> toMap() => {
    'cadeiraID': cadeiraID,
    'nome': nome,
    'sigla': sigla,
  };
}
