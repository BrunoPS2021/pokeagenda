class Habilidade {
  final int id;
  final String name;

  Habilidade({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Habilidade.fromMap(Map<String, dynamic> map) {
    return Habilidade(id: map['id'], name: map['name']);
  }
}
