import 'package:neapolis_car/main.dart';

class Post {
  final int id;
  final String type;
  final String descriptions;
  final String date_depart;
  final String date_fin;
  final String lien;
  final String photo; // This will be the URL of the photo
  Post({
    required this.id,
    required this.type,
    required this.descriptions,
    required this.date_depart,
    required this.date_fin,
    required this.lien,
    required this.photo,
  });
  String getPhotoUrl(String ip) {
    return ip + photo;
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      type: json['title'],
      descriptions: json['descriptions'],
      date_depart: json['date_depart'],
      date_fin: json['date_fin'],
      lien: json['lien'],
      photo: json['photo'],
    );
  }
}
