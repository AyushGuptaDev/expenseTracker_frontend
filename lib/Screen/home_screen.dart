import 'package:expense_tracker_with_node/river_pod/user_provider.dart';
import 'package:expense_tracker_with_node/widgets/drawer_home.dart';
import 'package:expense_tracker_with_node/widgets/expense_adder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Hello ${user!['userName']}')),
        drawer: DrawerHome(),
        body: Container(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ExpenseAdder.showBottomSheet(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
