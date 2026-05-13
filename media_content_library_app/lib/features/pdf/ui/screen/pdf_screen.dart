import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/const/widgets/common/try_again_widget.dart';
import 'package:media_content_library_app/features/pdf/data/model/pdf_model.dart';
import 'package:media_content_library_app/features/pdf/notifier/pdf_list/pdf_list_state_model.dart';
import 'package:media_content_library_app/features/pdf/ui/widget/pdf_item.dart';

import '../../notifier/pdf_list/pdf_list_notifier.dart';

class PdfScreen extends ConsumerStatefulWidget {
  const PdfScreen({super.key});

  @override
  ConsumerState<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends ConsumerState<PdfScreen> {
  final PdfProvider _provider = PdfProvider(() => PdfListNotifier());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_provider.notifier).getPdfList();
    });
  }

  @override
  Widget build(BuildContext context) {
    PdfListStateModel stateModel = ref.watch(_provider);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (stateModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (stateModel.isFailed) {
      return TryAgainWidget(
        onTryAgain: () {
          ref.read(_provider.notifier).getPdfList();
        },
      );
    }
    List<PdfData> pdfList = stateModel.pdfModel?.data ?? [];
    return ListView.builder(
      itemCount: pdfList.length,
      itemBuilder: (context, position) {
        PdfData data = pdfList[position];
        return PdfItem(data: data, colorScheme: colorScheme);
      },
    );
  }
}
