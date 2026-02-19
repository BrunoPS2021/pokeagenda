class Pokemon {
  final int id;
  final String name;
  final String url;
  final int height;
  final int weight;
  bool favorito;

  Pokemon({
    required this.id,
    required this.name,
    required this.url,
    required this.height,
    required this.weight,
    this.favorito = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'height': height,
      'weight': weight,
      'favorito': favorito ? 1 : 0,
    };
  }

  factory Pokemon.fromMap(Map<String, dynamic> map) {
    return Pokemon(
      id: map['id'],
      name: map['name'],
      url: map['url'],
      height: map['height'],
      weight: map['weight'],
      favorito: map['favorito'] == 1,
    );
  }
}
