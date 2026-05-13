import 'package:media_content_library_app/features/pdf/data/model/pdf_model.dart';

class PdfListStateModel {
  final bool isLoading;
  final bool isFailed;
  final bool isSuccess;
  final PdfModel? pdfModel;

  PdfListStateModel({
    this.isLoading = true,
    this.isFailed = false,
    this.isSuccess = false,
    this.pdfModel,
  });

  PdfListStateModel copyWith({
    bool? isLoading,
    bool? isFailed,
    bool? isSuccess,
    PdfModel? pdfModel,
  }) {
    return PdfListStateModel(
      isLoading: isLoading ?? this.isLoading,
      isFailed: isFailed ?? this.isFailed,
      isSuccess: isSuccess ?? this.isSuccess,
      pdfModel: pdfModel ?? this.pdfModel,
    );
  }
}
