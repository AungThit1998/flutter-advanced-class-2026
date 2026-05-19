import "package:dio/dio.dart";
import "package:go_router/go_router.dart";
import "package:media_content_library_app/const/storage/user_session.dart";
import "../apis/api_const.dart";
import "package:get_it/get_it.dart";

GetIt getIt = GetIt.I;
Future<void> setupLocator()async{
  GoRouter.optionURLReflectsImperativeAPIs = true;
  Dio dio = Dio();
  dio.options.baseUrl = ApiConst.baseUrl;
  getIt.registerSingleton<Dio>(dio);
  getIt.registerSingleton<UserSession>(UserSession());
}