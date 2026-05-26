class ApiConst {
  static const String baseUrl = "https://content-api.rubylearner.com/api/";
  static const blog = "blog";
  static const audio = "audio";
  static const video = "video";
  static const pdf = "pdf";
  static const signUpOTP = "auth/signup-otp";
  static const signUp = "auth/signup";
  static const signIn = "auth/login";

  static String addComment(String type, String id){
    return "content/$type/$id/comments";
  }

  ApiConst._();
}