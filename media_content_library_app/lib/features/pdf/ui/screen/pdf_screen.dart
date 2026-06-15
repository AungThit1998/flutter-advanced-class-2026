import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/const/responsive/responsive_layout.dart';
import 'package:media_content_library_app/const/widgets/common/try_again_widget.dart';
import 'package:media_content_library_app/features/pdf/data/model/pdf_model.dart';
import 'package:media_content_library_app/features/pdf/notifier/pdf_list/pdf_list_state_model.dart';
import 'package:media_content_library_app/features/pdf/ui/widget/pdf_item.dart';

import '../../notifier/pdf_list/pdf_list_notifier.dart';
import '../widget/desktop_pdf_list_widget.dart';
import '../widget/mobile_pdf_list_widget.dart';

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

    if (pdfList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.file_present_outlined,
              size: 80,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              "No pdf Found",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "There are no pdf items available at the moment.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return ResponsiveLayout(
      mobile: MobilePdfList(
        pdfList: pdfList,
        colorScheme: colorScheme,
        ref: ref,
        model: stateModel,
        pdfProvider: _provider,
      ),
      desktop: DesktopPdfList(
        pdfList: pdfList,
        colorScheme: colorScheme,
        ref: ref,
        pdfProvider: _provider,
        model: stateModel,
      ),
    );
  }
}
