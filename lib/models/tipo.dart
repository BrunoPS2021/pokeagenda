class Tipo {
  final int id;
  final String name;

  Tipo({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Tipo.fromMap(Map<String, dynamic> map) {
    return Tipo(id: map['id'], name: map['name']);
  }
}
