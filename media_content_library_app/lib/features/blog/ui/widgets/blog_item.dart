import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_content_library_app/const/responsive/responsive_utils.dart';
import 'package:media_content_library_app/features/blog/data/model/blog_model.dart';

import 'blog_cover_image.dart';

class BlogItem extends StatelessWidget {
  const BlogItem({super.key, required this.blogData});

  final BlogData blogData;

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveUtils.isMobile(context);
    return InkWell(
      onTap: (){
        context.push("/detail/${blogData.type}/${blogData.id}");
      },
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (isMobile)
                SizedBox(
                  height: 250,
                  child: BlogCoverImage(imageUrl: blogData.coverImage),
                ),
              if (!isMobile)
                Expanded(child: BlogCoverImage(imageUrl: blogData.coverImage)),
              Text(
                blogData.title ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: _MetaItem(
                      icon: Icon(Icons.person_outline,size: 14,),
                      value: blogData.author ?? "",
                    ),
                  ),
                  Expanded(
                    child: _MetaItem(
                      icon: Icon(Icons.mode_comment_outlined,size: 14,),
                      value: blogData.comments?.length.toString() ?? "",
                    ),
                  ),
                  Expanded(
                    child: _MetaItem(
                      icon: Icon(Icons.calendar_today_outlined,size: 14,),
                      value: blogData.createdAt?.split("T")[0] ?? "",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({super.key, required this.icon, required this.value});

  final Icon icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon,
        SizedBox(height: 4),
        Flexible(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
