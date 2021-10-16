class Song {
  int? id;
  String name;
  int num;
  String location;
  Song({
    this.id,
    required this.name,
    required this.num,
    required this.location,
  });

  Song.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        num = res['num'],
        location = res['location'];
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'num': num,
      'location': location,
    };
  }
}