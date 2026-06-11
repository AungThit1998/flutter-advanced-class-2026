class BookModel {
  BookModel({
    this.id,
    this.title,
    this.description,
    this.cover,
    this.fav,
    this.authorId,
    this.name,
    this.reference,
  });

  BookModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    cover = json['cover'];
    fav = json['fav'];
    authorId = json['author_id'];
    name = json['name'];
    reference = json['reference'];
  }
  num? id;
  String? title;
  String? description;
  dynamic cover;
  dynamic fav;
  num? authorId;
  String? name;
  String? reference;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['cover'] = cover;
    map['fav'] = fav;
    map['author_id'] = authorId;
    map['name'] = name;
    map['reference'] = reference;
    return map;
  }
}
