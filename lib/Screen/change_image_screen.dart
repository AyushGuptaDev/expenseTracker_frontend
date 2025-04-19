import 'package:expense_tracker_with_node/api_calls/edit_user.dart';
import 'package:expense_tracker_with_node/river_pod/user_provider.dart';
import 'package:expense_tracker_with_node/widgets/image_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeImageScreen extends ConsumerWidget {
  const ChangeImageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    final ValueNotifier<String?> imagePathNotifier = ValueNotifier(null);

    return Scaffold(
      appBar: AppBar(title: const Text("Change Cover Image")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageBox(
              imagePathNotifier: imagePathNotifier,
              buildPlaceholder:
                  () => DefaultImagePlaceholder(imageUrl: user!['coverImage']),
            ),

            SizedBox(height: 60),

            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  EditUser.changeCoverImage(
                    ref: ref,
                    context: context,
                    imagePathNotifier: imagePathNotifier,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text("Change Image", style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DefaultImagePlaceholder extends StatelessWidget {
  const DefaultImagePlaceholder({super.key, required this.imageUrl});

  final String imageUrl; // Not nullable now

  @override
  Widget build(BuildContext context) {
    return imageUrl.isNotEmpty
        ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        )
        : Container(
          width: 80,
          height: 80,
          color: Colors.grey[200],
          child: const Icon(Icons.person, size: 50, color: Colors.grey),
        );
  }
}
