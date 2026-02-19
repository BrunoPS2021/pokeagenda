class Sprite {
  final int? id; // Autoincrement no banco
  final int pokemonId;
  final String url;
  final String tipoImagem;

  Sprite({
    this.id,
    required this.pokemonId,
    required this.url,
    required this.tipoImagem,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pokemon_id': pokemonId,
      'url': url,
      'tipo_imagem': tipoImagem,
    };
  }

  factory Sprite.fromMap(Map<String, dynamic> map) {
    return Sprite(
      id: map['id'],
      pokemonId: map['pokemon_id'],
      url: map['url'],
      tipoImagem: map['tipo_imagem'],
    );
  }
}
