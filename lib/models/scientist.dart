class Scientist {
  final String id;
  final String name;
  final String title;
  String imagePath;
  String about;
  List<String> works;
  String? audioUrl;

  Scientist({
    required this.id,
    required this.name,
    required this.title,
    required this.imagePath,
    required this.about,
    required this.works,
    this.audioUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'title': title,
    'imagePath': imagePath,
    'about': about,
    'works': works,
    'audioUrl': audioUrl,
  };

  factory Scientist.fromJson(Map<String, dynamic> json) => Scientist(
    id: json['id'],
    name: json['name'],
    title: json['title'],
    imagePath: json['imagePath'],
    about: json['about'],
    works: List<String>.from(json['works'] ?? []),
    audioUrl: json['audioUrl'],
  );
}
