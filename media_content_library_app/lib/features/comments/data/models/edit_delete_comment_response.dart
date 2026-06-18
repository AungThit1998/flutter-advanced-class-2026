class EditDeleteCommentResponse {
  EditDeleteCommentResponse({this.message});

  EditDeleteCommentResponse.fromJson(dynamic json) {
    message = json['message'];
  }

  String? message;

  EditDeleteCommentResponse copyWith({String? message}) =>
      EditDeleteCommentResponse(message: message ?? this.message);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    return map;
  }
}
