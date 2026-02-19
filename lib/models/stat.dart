class Stat {
  final int id;
  final String name;

  Stat({required this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Stat.fromMap(Map<String, dynamic> map) {
    return Stat(id: map['id'], name: map['name']);
  }
}
