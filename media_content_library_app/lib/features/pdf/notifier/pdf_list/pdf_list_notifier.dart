import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/model/pdf_model.dart';
import '../../data/services/pdf_services.dart';
import 'pdf_list_state_model.dart';

typedef PdfProvider = NotifierProvider<PdfListNotifier,PdfListStateModel>;
class PdfListNotifier extends Notifier<PdfListStateModel>{
  final PdfServices _services = PdfServices();
  @override
  PdfListStateModel build() {
    return PdfListStateModel();
  }
  void getPdfList() async{
    try {
      state = state.copyWith(
        isLoading: true,
        isSuccess: false,
        isFailed: false,
      );
      PdfModel pdfModel = await _services.getPdfList();
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        pdfModel: pdfModel,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isFailed: true,
      );
    }
  }
}