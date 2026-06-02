

import 'package:media_content_library_app/features/pdf/data/model/pdf_model.dart';

class PdfDetailStateModel {
  final bool isLoading;
  final bool isError;
  final bool isSuccess;
  final PdfData? pdfData;

  PdfDetailStateModel({
    this.isLoading = true,
    this.isError = false,
    this.isSuccess = false,
    this.pdfData,
  });

  PdfDetailStateModel copWith({
    bool? isLoading,
    bool? isError,
    bool? isSuccess,
    PdfData? pdfData,
  }) {
    return PdfDetailStateModel(
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      isSuccess: isSuccess ?? this.isSuccess,
      pdfData: pdfData ?? this.pdfData,
    );
  }
}
