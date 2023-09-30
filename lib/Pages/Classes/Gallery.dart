class Gallery {
  int idPhoto;
  String photo;
  String titleGallery;
  int listExurcion;

  Gallery({
    required this.idPhoto,
    required this.photo,
    required this.titleGallery,
    required this.listExurcion,
  });

  factory Gallery.fromJson(Map<String, dynamic> json) {
    return Gallery(
      idPhoto: json['idPhoto'] as int,
      photo: json['photo'] as String,
      titleGallery: json['titleGallery'] as String,
      listExurcion: json['listExurcion'] as int,
    );
  }
}
