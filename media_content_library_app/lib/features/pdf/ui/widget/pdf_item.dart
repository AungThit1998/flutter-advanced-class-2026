import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_content_library_app/const/apis/api_const.dart';
import 'package:media_content_library_app/features/pdf/data/model/pdf_model.dart';
import 'package:media_content_library_app/features/video/data/models/video_model.dart';

import '../../../blog/ui/widgets/blog_cover_image.dart';

class PdfItem extends StatelessWidget {
  const PdfItem({
    super.key,
    required this.data,
    required this.colorScheme,
  });

  final PdfData data;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.push("/detail/${ApiConst.pdf}/${data.id}");
      },
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: BoxBorder.all(),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: BlogCoverImage(imageUrl: data.previewImage),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only( left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        data.fileSize ?? "",
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text("${data.pages} pages"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
