class HistoricoAtualizacao {
  final int? id; // Autoincrement
  final int countPokemons;
  final String dataUltimaAtualizacao;
  final bool sucesso;

  HistoricoAtualizacao({
    this.id,
    required this.countPokemons,
    required this.dataUltimaAtualizacao,
    required this.sucesso,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'count_pokemons': countPokemons,
      'data_ultima_atualizacao': dataUltimaAtualizacao,
      'sucesso': sucesso ? 1 : 0, // SQLite não tem boolean
    };
  }

  factory HistoricoAtualizacao.fromMap(Map<String, dynamic> map) {
    return HistoricoAtualizacao(
      id: map['id'],
      countPokemons: map['count_pokemons'],
      dataUltimaAtualizacao: map['data_ultima_atualizacao'],
      sucesso: map['sucesso'] == 1,
    );
  }
}
