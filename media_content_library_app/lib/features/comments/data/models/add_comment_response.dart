class AddCommentResponse {
  AddCommentResponse({
      this.id, 
      this.user, 
      this.userId, 
      this.text, 
      this.createdAt,});

  AddCommentResponse.fromJson(dynamic json) {
    id = json['id'];
    user = json['user'];
    userId = json['userId'];
    text = json['text'];
    createdAt = json['createdAt'];
  }
  num? id;
  String? user;
  num? userId;
  String? text;
  String? createdAt;
AddCommentResponse copyWith({  num? id,
  String? user,
  num? userId,
  String? text,
  String? createdAt,
}) => AddCommentResponse(  id: id ?? this.id,
  user: user ?? this.user,
  userId: userId ?? this.userId,
  text: text ?? this.text,
  createdAt: createdAt ?? this.createdAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user'] = user;
    map['userId'] = userId;
    map['text'] = text;
    map['createdAt'] = createdAt;
    return map;
  }

}