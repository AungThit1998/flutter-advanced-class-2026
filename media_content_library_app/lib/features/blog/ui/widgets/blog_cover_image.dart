import 'package:flutter/material.dart';

class BlogCoverImage extends StatelessWidget {
  const BlogCoverImage({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return imageUrl == null
        ? Container(
            color: colorScheme.surfaceContainerHighest,
            child: Icon(Icons.image_outlined, size: 34),
          )
        : Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Icon(Icons.image_rounded, size: 80),
              );
            },
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                color: colorScheme.surfaceContainerHighest,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            },
          );
  }
}
