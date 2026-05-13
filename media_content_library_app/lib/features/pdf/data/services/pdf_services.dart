import 'package:dio/dio.dart';

import '../../../../const/apis/api_const.dart';
import '../../../../const/di/locator.dart';
import '../model/pdf_model.dart';

class PdfServices {
  final Dio _dio = getIt.get();

  Future<PdfModel> getPdfList({int page = 1, int limit = 10}) async {
    final response = await _dio.get(
      "content",
      queryParameters: {"type": ApiConst.pdf, "page": page, "limit": limit},
    );
    return PdfModel.fromJson(response.data);
  }
  Future<PdfData> getPdfDetail({required String type,required String id}) async{
    final response = await _dio.get("content/$type/$id");
    return PdfData.fromJson(response.data);
  }
}