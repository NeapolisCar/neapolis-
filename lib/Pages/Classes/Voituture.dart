import 'package:neapolis_car/main.dart';

class Voiture {
  final String numeroSeries;
  final String modele;
  final String nbSeats;
  final String nbBags;
  final String nbPorts;
  final double prixJour;
  final double caution;
  final String annee;
  final String etat;
  final String marque;
  final String photoMarque;
  final String photo;
  final String disponibilite; // This will be the URL of the photo
  Voiture({
    required this.numeroSeries,
    required this.modele,
    required this.nbSeats,
    required this.nbBags,
    required this.nbPorts,
    required this.prixJour,
    required this.caution,
    required this.annee,
    required this.etat,
    required this.marque,
    required this.photoMarque,
    required this.photo,
    required this.disponibilite,
  });
  String getPhotoUrl(String ip) {
    return ip + photo;
  }

  factory Voiture.fromJson(Map<String, dynamic> json) {
    return Voiture(
        numeroSeries: json['numero_series'],
        modele: json['modele'],
        nbSeats: json['nb_seats'],
        nbBags: json['nb_bags'],
        nbPorts: json['nb_ports'],
        prixJour: json['prix_jour'],
        caution: json['caution'],
        annee: json['annee'],
        etat: json['etat'],
        marque:json['marque'],
        photoMarque : json['photoMarque'],
        photo: json['photo'],
        disponibilite: json['disponibilite']
    );
  }
}