import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_content_library_app/const/apis/api_const.dart';
import 'package:media_content_library_app/const/responsive/responsive_utils.dart';
import 'package:media_content_library_app/features/video/data/models/video_model.dart';

import '../../../blog/ui/widgets/blog_cover_image.dart';

class VideoItem extends StatefulWidget {
  const VideoItem({super.key, required this.data, required this.colorScheme});

  final VideoData data;
  final ColorScheme colorScheme;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveUtils.isDesktop(context);

    return isDesktop
        ? DesktopVideoItem(widget: widget)
        : MobileVideoItem(widget: widget);
  }
}

class MobileVideoItem extends StatelessWidget {
  const MobileVideoItem({super.key, required this.widget});

  final VideoItem widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push("/detail/${ApiConst.video}/${widget.data.id}");
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
              child: BlogCoverImage(imageUrl: widget.data.thumbnail),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.data.title ?? "",
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
                        color: widget.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.data.source ?? "",
                        style: TextStyle(
                          color: widget.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(widget.data.duration ?? ""),
                  ],
                ),
              ),
            ),
            Icon(Icons.play_circle_fill_rounded),
          ],
        ),
      ),
    );
  }
}

class DesktopVideoItem extends StatefulWidget {
  const DesktopVideoItem({super.key, required this.widget});

  final VideoItem widget;

  @override
  State<DesktopVideoItem> createState() => _DesktopVideoItemState();
}

class _DesktopVideoItemState extends State<DesktopVideoItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _isHovered
              ? widget.widget.colorScheme.surfaceContainerHighest
              : widget.widget.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? widget.widget.colorScheme.primary.withValues(alpha: 0.3)
                : widget.widget.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.widget.colorScheme.shadow.withValues(
                      alpha: 0.1,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.push(
                "/detail/${ApiConst.video}/${widget.widget.data.id}",
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail Section
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          height: 140,
                          width: double.infinity,
                          child: BlogCoverImage(
                            imageUrl: widget.widget.data.thumbnail,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.widget.data.duration ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: AnimatedOpacity(
                            opacity: _isHovered ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: widget.widget.colorScheme.primary
                                    .withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.play_arrow,
                                color: widget.widget.colorScheme.onPrimary,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Title Section
                  Flexible(
                    child: Text(
                      widget.widget.data.title ?? "Unknown Title",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: widget.widget.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  const SizedBox(height: 8),
                  // Type Badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.widget.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.widget.data.type ?? "Audio",
                          style: TextStyle(
                            color: widget.widget.colorScheme.onPrimaryContainer,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
