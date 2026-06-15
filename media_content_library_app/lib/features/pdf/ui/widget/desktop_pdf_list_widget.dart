import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_content_library_app/features/pdf/data/model/pdf_model.dart';
import 'package:media_content_library_app/features/pdf/notifier/pdf_list/pdf_list_notifier.dart';
import 'package:media_content_library_app/features/pdf/notifier/pdf_list/pdf_list_state_model.dart';
import 'package:media_content_library_app/features/pdf/ui/widget/pdf_item.dart';

class DesktopPdfList extends StatefulWidget {
  const DesktopPdfList({
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
  State<DesktopPdfList> createState() => _DesktopPdfListState();
}

class _DesktopPdfListState extends State<DesktopPdfList> {
  final ScrollController _scrollController = ScrollController();
  bool _loadCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            trackVisibility: true,
            child: GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 320,
                mainAxisExtent: 280,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: widget.pdfList.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.pdfList.length) {
                  bool isLoadCompleted = index == widget.model.pdfModel?.total;
                  if (_loadCompleted != isLoadCompleted) {
                    Future(() {
                      setState(() {
                        _loadCompleted = isLoadCompleted;
                      });
                    });
                  }
                  if (widget.model.isPaginateLoading == false &&
                      !isLoadCompleted) {
                    Future(() {
                      widget.ref.read(widget._pdfProvider.notifier).loadMore();
                    });
                  }
                  return SizedBox.shrink();
                }
                PdfData data = widget.pdfList[index];
                return PdfItem(data: data, colorScheme: widget.colorScheme);
              },
            ),
          ),
        ),
        if (_loadCompleted)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: widget.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                "All items loaded",
                style: TextStyle(
                  color: widget.colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        if (widget.model.isPaginateLoading)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: widget.colorScheme.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
