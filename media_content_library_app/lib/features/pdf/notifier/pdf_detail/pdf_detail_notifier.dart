
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../const/apis/api_const.dart';
import '../../data/model/pdf_model.dart';
import '../../data/services/pdf_services.dart';
import 'pdf_detail_state_model.dart';


typedef PdfDetailProvider = NotifierProvider<PdfDetailNotifier,PdfDetailStateModel>;
class PdfDetailNotifier extends Notifier<PdfDetailStateModel> {
  final PdfServices _pdfServices = PdfServices();

  @override
  PdfDetailStateModel build() {
    return PdfDetailStateModel();
  }

  void getPdf(String? id) async {
    state = state.copWith(isLoading: true, isSuccess: false, isError: false);
    if(id == null){
      state = state.copWith(isLoading: false,isError: true);
      return;
    }
    try {
      PdfData pdfData = await _pdfServices.getPdfDetail(
        type: ApiConst.pdf,
        id: id,
      );
      state = state.copWith(
        isLoading: false,
        isSuccess: true,
        pdfData: pdfData,
      );
    } catch (e) {
      state = state.copWith(isLoading: false, isError: true);
    }
  }
}
