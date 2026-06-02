import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/const/apis/api_const.dart';
import 'package:media_content_library_app/const/widgets/common/try_again_widget.dart';
import 'package:media_content_library_app/features/pdf/data/model/pdf_model.dart';
import 'package:media_content_library_app/features/pdf/notifier/pdf_detail/pdf_detail_state_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../notifier/pdf_detail/pdf_detail_notifier.dart';

class PdfDetailScreen extends ConsumerStatefulWidget {
  const PdfDetailScreen({super.key, required this.id});

  final String? id;

  @override
  ConsumerState<PdfDetailScreen> createState() => _PdfDetailScreenState();
}

class _PdfDetailScreenState extends ConsumerState<PdfDetailScreen> {
  final PdfDetailProvider _pdfDetailProvider = PdfDetailProvider(() {
    return PdfDetailNotifier();
  });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_pdfDetailProvider.notifier).getPdf(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    PdfDetailStateModel stateModel = ref.watch(_pdfDetailProvider);
    return Scaffold(
      appBar: AppBar(title: Text(stateModel.pdfData?.title ?? "......")),
      body: _pdfDetailBody(),
    );
  }

  Widget _pdfDetailBody() {
    PdfDetailStateModel stateModel = ref.watch(_pdfDetailProvider);
    if (stateModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (stateModel.isError) {
      return TryAgainWidget(
        onTryAgain: () {
          ref.read(_pdfDetailProvider.notifier).getPdf(widget.id);
        },
      );
    }
    PdfData? pdfData = stateModel.pdfData;
    String? url = pdfData?.url;
    return url?.isNotEmpty == true
        ? kIsWeb
              ? Center(
                  child: Column(
                    children: [
                      if(pdfData?.previewImage != null)
                      Image.network(pdfData!.previewImage!),
                      if(pdfData?.previewImage != null)
                        SizedBox(height: 8,),
                      ElevatedButton(
                        onPressed: () {
                          launchUrl(Uri.parse(url!),);
                        },
                        child: Text("View/Download Pdf"),
                      ),
                    ],
                  ),
                )
              : SfPdfViewer.network(url!)
        : SizedBox.shrink();
  }
}
