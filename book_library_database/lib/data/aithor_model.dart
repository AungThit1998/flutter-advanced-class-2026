import 'dart:typed_data';

class AuthorModel {
  final int id;
  final String name;
  final String description;
  final Uint8List? photo;
  final int? fav;

  AuthorModel({
    required this.id,
    required this.name,
    required this.description,
    required this.photo,
    required this.fav,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      photo: json['photo'],
      fav: json['fav'],
    );
  }
}
