class ProfileStateModel {
  final String? name;
  final String? email;
  final String? id;
  final String? token;

  ProfileStateModel({this.name, this.email, this.id, this.token});

  ProfileStateModel copyWith({
    String? name,
    String? email,
    String? id,
    String? token,
  }) {
    return ProfileStateModel(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }
}
