class Options{
  final int id;
  final String title;
  final String descriptions;
  final String numeroSeries;

  Options({
    required this.id,
    required this.title,
    required this.descriptions,
    required this.numeroSeries,
  });

  factory Options.fromJson(Map<String, dynamic> json) {
    return Options(
      id: json['id'],
      title: json['title'],
      descriptions: json['descriptions'],
      numeroSeries: json['numero_series'],
    );
  }
}

