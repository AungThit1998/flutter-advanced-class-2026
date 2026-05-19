import 'package:dio/dio.dart';
import '../../../../const/apis/api_const.dart';
import '../../../../const/di/locator.dart';
import '../models/sign_up/sign_up_model.dart';
import '../models/sign_up/sign_up_otp_model.dart';

class AuthApiServices {
  final Dio _dio = getIt.get();

  Future<SignUpOtpModel> getOTP({required String email}) async {
    final response = await _dio.post(
      ApiConst.signUpOTP,
      data: {"email": email},
    );
    return SignUpOtpModel.fromJson(response.data);
  }

  Future<SignUpModel> signup({
    required String name,
    required String email,
    required String otp,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConst.signUp,
      data: {"name": name, "email": email, "otp": otp, "password": password},
    );
    return SignUpModel.fromJson(response.data);
  }
}
