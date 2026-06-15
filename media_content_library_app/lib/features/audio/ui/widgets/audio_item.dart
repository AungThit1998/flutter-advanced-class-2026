import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:media_content_library_app/const/apis/api_const.dart';
import '../../../../const/responsive/responsive_utils.dart';
import '../../../blog/ui/widgets/blog_cover_image.dart';
import '../../data/model/audio_model.dart';

class AudioItem extends StatefulWidget {
  const AudioItem({super.key, required this.data, required this.colorScheme});

  final AudioData data;
  final ColorScheme colorScheme;

  @override
  State<AudioItem> createState() => _AudioItemState();
}

class _AudioItemState extends State<AudioItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = ResponsiveUtils.isDesktop(context);

    Widget mobileAudioItem() {
      return InkWell(
        onTap: () {
          context.push("/detail/${ApiConst.audio}/${widget.data.id}");
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
                          widget.data.type ?? "",
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

    return isDesktop ? desktopAudioItem() : mobileAudioItem();
  }

  Widget desktopAudioItem() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _isHovered
              ? widget.colorScheme.surfaceContainerHighest
              : widget.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? widget.colorScheme.primary.withValues(alpha: 0.3)
                : widget.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.colorScheme.shadow.withValues(alpha: 0.1),
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
              context.push("/detail/${ApiConst.audio}/${widget.data.id}");
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
                            imageUrl: widget.data.thumbnail,
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
                            widget.data.duration ?? "",
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
                                color: widget.colorScheme.primary.withValues(
                                  alpha: 0.9,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.play_arrow,
                                color: widget.colorScheme.onPrimary,
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
                      widget.data.title ?? "Unknown Title",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: widget.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Artist Section
                  Text(
                    widget.data.artist ?? "Unknown Artist",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: widget.colorScheme.onSurfaceVariant,
                    ),
                  ),
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
                          color: widget.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.data.type ?? "Audio",
                          style: TextStyle(
                            color: widget.colorScheme.onPrimaryContainer,
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
