class Character {
  final String id;
  final String name;
  final String image;

  const Character({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "id": String id,
        "name": String name,
        "image": String image,
      } =>
        Character(
          id: id,
          name: name,
          image: image,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }

  @override
  String toString() {
    return 'Character{id: $id, name: $name, image: $image}';
  }
}
