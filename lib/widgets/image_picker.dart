import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> showImagePicker(
  BuildContext context,
  ValueNotifier<String?> imagePathNotifier,
) async {
  final ImagePicker picker = ImagePicker();

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 7,
                width: 50,

                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _imageOption(
                    context,
                    label: "camera",
                    colour: Colors.blue,
                    icon: Icons.camera,
                    onTap: () async {
                      final pikedFile = await picker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (pikedFile != null) {
                        imagePathNotifier.value = pikedFile.path;
                      }
                      Navigator.pop(context);
                    },
                  ),

                  _imageOption(
                    context,
                    label: "Gallery",
                    colour: Colors.green,
                    icon: Icons.photo_library,
                    onTap: () async {
                      final pikerFile = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pikerFile != null) {
                        imagePathNotifier.value = pikerFile.path;
                      }
                      Navigator.pop(context);
                    },
                  ),

                  _imageOption(
                    context,
                    label: "Remove",
                    colour: Colors.red,
                    icon: Icons.delete,
                    onTap: () async {
                      imagePathNotifier.value = null;
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _imageOption(
  BuildContext context, {
  required String label,
  required Color colour,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: colour.withAlpha(26),
          child: Icon(icon, size: 30, color: colour),
        ),
        SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    ),
  );
}
