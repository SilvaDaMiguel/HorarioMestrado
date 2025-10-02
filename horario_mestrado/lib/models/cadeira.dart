import 'dart:convert'; //Carregar JSONs

class Cadeira {
  final int cadeiraID;
  final String nome;
  final String sigla;
  final String informacao;
  final List<String>? professores;

  Cadeira({
    required this.cadeiraID,
    required this.nome,
    required this.sigla,
    this.informacao = 'Sem Informação',
    this.professores = const [],
  });

  factory Cadeira.fromMap(Map<String, dynamic> map) => Cadeira(
  cadeiraID: map['cadeiraID'],
  nome: map['nome'] ?? 'Nome Não Definido',
  sigla: map['sigla'] ?? 'Sigla Não Definida',
  informacao: map['informacao'] ?? 'Sem Informação',
  professores: map['professores'] != null
      ? List<String>.from(jsonDecode(map['professores']))
      : [],
);

Map<String, dynamic> toMap() => {
  'cadeiraID': cadeiraID,
  'nome': nome,
  'sigla': sigla,
  'informacao': informacao,
  'professores': jsonEncode(professores), // 🔹 salvar sempre como JSON string
};
}
