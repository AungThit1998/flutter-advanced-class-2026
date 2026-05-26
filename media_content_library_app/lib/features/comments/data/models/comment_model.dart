class CommentModel {
  CommentModel({
    this.id,
    this.user,
    this.userId,
    this.text,
    this.createdAt,
    this.isOwn,
  });

  CommentModel.fromJson(dynamic json) {
    id = json['id'];
    user = json['user'];
    userId = json['userId'];
    text = json['text'];
    createdAt = json['createdAt'];
    isOwn = json['isOwn'];
  }

  num? id;
  String? user;
  num? userId;
  String? text;
  String? createdAt;
  bool? isOwn;

  CommentModel copyWith({
    num? id,
    String? user,
    num? userId,
    String? text,
    String? createdAt,
    bool? isOwn,
  }) => CommentModel(
    id: id ?? this.id,
    user: user ?? this.user,
    userId: userId ?? this.userId,
    text: text ?? this.text,
    createdAt: createdAt ?? this.createdAt,
    isOwn: isOwn ?? this.isOwn,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user'] = user;
    map['userId'] = userId;
    map['text'] = text;
    map['createdAt'] = createdAt;
    map['isOwn'] = isOwn;
    return map;
  }
}
