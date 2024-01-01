import 'package:neapolis_car/main.dart';

class Voiture {
  final String numeroSeries;
  final String modele;
  final int nbSeats;
  final int nbBags;
  final int nbPorts;
  final double prixJour;
  final double caution;
  final String annee;
  final String etat;
  final String photo;
  final int id_marquer;
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
    required this.photo,
    required this.id_marquer
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
        photo: json['photo'],
        id_marquer : json['id_marquer']
    );
  }
}