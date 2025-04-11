import 'package:expense_tracker_with_node/river_pod/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = (ref.watch(userProvider));
    final imageUrl = user!['coverImage'];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Hello ${user['userName']}')),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Center(
                  child: ClipOval(
                    child:
                        imageUrl!.isNotEmpty
                            ? Image.network(imageUrl)
                            : Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey[800],
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(),
      ),
    );
  }
}
