class SignUpModel {
  SignUpModel({this.message, this.token, this.user});

  SignUpModel.fromJson(dynamic json) {
    message = json['message'];
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  String? message;
  String? token;
  User? user;

  SignUpModel copyWith({String? message, String? token, User? user}) =>
      SignUpModel(
        message: message ?? this.message,
        token: token ?? this.token,
        user: user ?? this.user,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    map['token'] = token;
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }
}

class User {
  User({this.id, this.name, this.email});

  User.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  num? id;
  String? name;
  String? email;

  User copyWith({num? id, String? name, String? email}) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    return map;
  }
}
