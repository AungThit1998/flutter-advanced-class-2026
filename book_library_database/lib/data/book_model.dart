class BookModel {
  BookModel({
      this.id, 
      this.title, 
      this.description, 
      this.cover, 
      this.authorId,});

  BookModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    cover = json['cover'];
    authorId = json['author_id'];
  }
  num? id;
  String? title;
  String? description;
  dynamic cover;
  num? authorId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['cover'] = cover;
    map['author_id'] = authorId;
    return map;
  }

}