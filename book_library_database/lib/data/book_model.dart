class BookModel {
  BookModel({
      this.id, 
      this.title, 
      this.description, 
      this.cover, 
      this.fav, 
      this.authorId, 
      this.name,});

  BookModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    cover = json['cover'];
    fav = json['fav'];
    authorId = json['author_id'];
    name = json['name'];
  }
  num? id;
  String? title;
  String? description;
  dynamic cover;
  dynamic fav;
  num? authorId;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['cover'] = cover;
    map['fav'] = fav;
    map['author_id'] = authorId;
    map['name'] = name;
    return map;
  }

}