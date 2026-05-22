class JokeModel {
  final String type;
  final String setup;
  final String punchline;
  final int id;

  JokeModel({
    required this.type,
    required this.setup,
    required this.punchline,
    required this.id,
  });

  factory JokeModel.fromJson(Map<String, dynamic> json) => JokeModel(
        type: json['type'] as String,
        setup: json['setup'] as String,
        punchline: json['punchline'] as String,
        id: json['id'] as int,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'setup': setup,
        'punchline': punchline,
        'id': id,
      };
}
