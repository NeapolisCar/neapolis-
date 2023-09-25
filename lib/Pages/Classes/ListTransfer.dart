class LisTransfer {
  final int id;
  final String addressDepart;
  final String addressFin;
  final double prix;

  LisTransfer({
    required this.id,
    required this.addressDepart,
    required this.addressFin,
    required this.prix,
  });

  factory LisTransfer.fromJson(Map<String, dynamic> json) {
    return LisTransfer(
      id: json['id'] as int,
      addressDepart: json['address_depart'] as String,
      addressFin: json['address_fin'] as String,
      prix: json['prix'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address_depart': addressDepart,
      'address_fin': addressFin,
      'prix': prix,
    };
  }
}
