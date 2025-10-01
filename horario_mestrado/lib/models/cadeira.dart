class Cadeira {
  final int cadeiraID;
  final String nome;
  final String sigla;
  final String informacao;

  Cadeira({
    required this.cadeiraID,
    required this.nome,
    required this.sigla,
    this.informacao = "Sem Infromação",
  });

  factory Cadeira.fromMap(Map<String, dynamic> map) => Cadeira(
    cadeiraID: map['cadeiraID'],
    nome: map['nome'] ?? "Nome Não Definido",
    sigla: map['sigla'] ?? "Sigla Não Definida",
    informacao: map['informacao'] ?? "Sem Informação",
  );

  Map<String, dynamic> toMap() => {
    'cadeiraID': cadeiraID,
    'nome': nome,
    'sigla': sigla,
    'informacao': informacao,
  };
}
