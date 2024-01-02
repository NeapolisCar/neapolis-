import 'package:neapolis_car/main.dart';

class Marquer {
    final int id;
    final String nom;
    final String logo;
  Marquer({
    required this.id,
    required this.nom,
    required this.logo,

  });
  String getPhotoUrl(String ip) {
    return ip + logo;
  }

  factory Marquer.fromJson(Map<String, dynamic> json) {
    return Marquer(
      id: json['id'],
      nom: json['nom'],
      logo: json['logo'],
    );
  }
}