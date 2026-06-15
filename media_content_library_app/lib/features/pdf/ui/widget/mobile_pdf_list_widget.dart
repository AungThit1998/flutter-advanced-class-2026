import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/features/pdf/data/model/pdf_model.dart';
import 'package:media_content_library_app/features/pdf/notifier/pdf_list/pdf_list_notifier.dart';
import 'package:media_content_library_app/features/pdf/notifier/pdf_list/pdf_list_state_model.dart';
import 'package:media_content_library_app/features/pdf/ui/widget/pdf_item.dart';

class MobilePdfList extends StatelessWidget {
  const MobilePdfList({
    super.key,
    required this.pdfList,
    required this.colorScheme,
    required this.ref,
    required PdfProvider pdfProvider,
    required this.model,
  }) : _pdfProvider = pdfProvider;

  final List<PdfData> pdfList;
  final ColorScheme colorScheme;
  final WidgetRef ref;
  final PdfProvider _pdfProvider;
  final PdfListStateModel model;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pdfList.length + 1,
      itemBuilder: (context, index) {
        if (index == pdfList.length) {
          if (index == model.pdfModel?.total) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Load Completed"),
              ),
            );
          }
          if (model.isPaginateLoading == false) {
            Future(() {
              ref.read(_pdfProvider.notifier).loadMore();
            });
          }
          return Container(
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
        PdfData pdfData = pdfList[index];
        return PdfItem(data: pdfData, colorScheme: colorScheme);
      },
    );
  }
}
