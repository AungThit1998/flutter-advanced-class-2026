class DatabaseModel {
  final int id;
  final String eng;
  final String myan;
  final String type;
  final int? favourite;

  DatabaseModel({
    required this.id,
    required this.eng,
    required this.myan,
    required this.type,
    required this.favourite,
  });

  factory DatabaseModel.fromMap(Map<String, dynamic> map) {
    return DatabaseModel(
      id: map['id'],
      eng: map['eng'],
      myan: map['myan'],
      type: map['type'],
      favourite: map['favourite'],
    );
  }

  @override
  String toString() {
    return 'DatabaseModel{id: $id, eng: $eng, myan: $myan, type: $type, favourite: $favourite}';
  }
}
