class Quest {
  final String name;
  final String complexity;
  final List<String> tags;
  final List<String> badges;
  final int points;
  final String frequency;

  const Quest({
    required this.name,
    required this.complexity,
    this.tags = const [],
    this.badges = const [],
    this.points = 0,
    this.frequency = 'weekly',
  });

  String get search => tags.join(',');

  String get key => name;

  String get displayName => name;

  static Quest? fromJson(Map<String, dynamic> json) {
    if (json
        case {
          "name": String name,
          "complexity": String complexity,
          "tags": List<dynamic> tags?,
          "badges": List<dynamic> badges?,
          "points": int points?,
          "frequency": String frequency?,
        }) {
      return Quest(
        name: name,
        complexity: complexity,
        tags: tags.cast<String>(),
        badges: badges.cast<String>(),
        points: points,
        frequency: frequency,
      );
    }
    return null;
  }

  @override
  String toString() {
    return 'Quest{name: $name, complexity: $complexity, tags: $tags, badges: $badges, points: $points, frequency: $frequency}';
  }
}
