class Evolucao {
  final int? id; // Autoincrement
  final int pokemonId;
  final int evoluiParaId;
  final String metodo;
  final int? nivel; // Nem toda evolução tem nível

  Evolucao({
    this.id,
    required this.pokemonId,
    required this.evoluiParaId,
    required this.metodo,
    this.nivel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pokemon_id': pokemonId,
      'evolui_para_id': evoluiParaId,
      'metodo': metodo,
      'nivel': nivel,
    };
  }

  factory Evolucao.fromMap(Map<String, dynamic> map) {
    return Evolucao(
      id: map['id'],
      pokemonId: map['pokemon_id'],
      evoluiParaId: map['evolui_para_id'],
      metodo: map['metodo'],
      nivel: map['nivel'],
    );
  }
}
