import 'package:neapolis_car/main.dart';

class Client {
  final int id;
  final String nomprenom;
  final String numeroparmis;
  final String nomentrprise;
  final String cin;
  final String paye;
  final String numerorue;
  final String telephone;
  final String ville;
  final String region;
  final String email;
  final String mot_de_passe;
  final String photo_parmis; // This will be the URL of the photo
  final String photo_cin_passport; // This will be the URL of the photo
  final String points;
  final String photo; // This will be the URL of the photo

  Client({
    required this.id,
    required this.nomprenom,
    required this.numeroparmis,
    required this.nomentrprise,
    required this.cin,
    required this.paye,
    required this.numerorue,
    required this.telephone,
    required this.ville,
    required this.region,
    required this.email,
    required this.mot_de_passe,
    required this.photo_parmis,
    required this.photo_cin_passport,
    required this.points,
    required this.photo,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] ?? '',
      nomprenom: json['nomprenom'] ?? '',
      numeroparmis: json['numeroparmis'] ?? '',
      nomentrprise: json['nomentrprise'] ?? '',
      cin: json['cin']?.toString() ?? '',
      paye: json['paye'] ?? '',
      numerorue: json['numerorue'] ?? '',
      telephone: json['telephone']?.toString() ?? '',
      ville: json['ville'] ?? '',
      region: json['region'] ?? '',
      email: json['email'] ?? '',
      mot_de_passe: json['mot_de_passe'] ?? '',
      photo_parmis:
          (json['photo_parmis'] != null) ? ip + json['photo_parmis'] : '',
      photo_cin_passport: (json['photo_cin_passport'] != null)
          ?  json['photo_cin_passport']
          : '',
      points: json['points']?.toString() ?? '',
      photo: (json['photo'] != null) ? json['photo'] : '',
    );
  }
}
