class ListExurcion {
  final int id;
  final String addressDepart;
  final String? description;
  final double prix;

  ListExurcion({
    required this.id,
    required this.addressDepart,
    this.description,
    required this.prix,
  });

  factory ListExurcion.fromJson(Map<String, dynamic> json) {
    return ListExurcion(
      id: json['id'] as int,
      addressDepart: json['address_depart'] as String,
      description: json['description'] as String?,
      prix: json['prix'] as double,
    );
  }

}
