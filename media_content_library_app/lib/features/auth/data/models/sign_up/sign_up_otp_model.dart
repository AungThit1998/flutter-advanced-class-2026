class SignUpOtpModel {
  SignUpOtpModel({this.message});

  SignUpOtpModel.fromJson(dynamic json) {
    message = json['message'];
  }

  String? message;

  SignUpOtpModel copyWith({String? message}) =>
      SignUpOtpModel(message: message ?? this.message);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    return map;
  }
}
