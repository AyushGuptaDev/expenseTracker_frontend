import 'dart:io';

import 'package:expense_tracker_with_node/widgets/image_picker.dart';
import 'package:flutter/material.dart';

class ImageBox extends StatelessWidget {
  const ImageBox({
    super.key,
    required this.imagePathNotifier,
    this.buildPlaceholder,
  });

  final ValueNotifier<String?> imagePathNotifier;
  final Widget Function()? buildPlaceholder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        showImagePicker(context, imagePathNotifier);
      },
      child: ValueListenableBuilder<String?>(
        valueListenable: imagePathNotifier,
        builder: (context, path, _) {
          return Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child:
                path != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(File(path), fit: BoxFit.cover),
                    )
                    : buildPlaceholder?.call() ??
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 40,
                              color: theme.iconTheme.color?.withAlpha(150),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Upload cover image",
                              style: TextStyle(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withAlpha(150),
                              ),
                            ),
                          ],
                        ),
          );
        },
      ),
    );
  }
}
