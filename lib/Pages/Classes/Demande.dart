import 'package:neapolis_car/main.dart';

class Demande {
  final int id;
  final String type;
  final String photo; // This will be the URL of the photo
  final String modele;
  final double prix;
  final String etat;
  final String date_de_depart;
  final String date_de_revinier;
  final String address_depart;
  final String address_fin;
  final String date;
  Demande({
    required this.id,
    required this.type,
    required this.photo,
    required this.modele,
    required this.prix,
    required this.etat,
    required this.date_de_depart,
    required this.date_de_revinier,
    required this.address_depart,
    required this.address_fin,
    required this.date,
  });
  factory Demande.fromJson(Map<String, dynamic> json) {
    return Demande(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      photo: (json['photo'] != null) ? json['photo'] : '',
      modele: json['modele'] ?? '',
      prix: json['prix'] ?? '',
      etat: json['etat'] ?? '',
      date_de_depart: json['date_de_depart'] ?? '',
      date_de_revinier: json['date_de_revinier'] ?? '',
      address_depart: json['address_depart'] ?? '',
      address_fin: json['address_fin'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
