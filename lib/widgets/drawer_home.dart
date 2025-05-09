import 'package:expense_tracker_with_node/Screen/change_image_screen.dart';
import 'package:expense_tracker_with_node/Screen/change_password_screen.dart';
import 'package:expense_tracker_with_node/Screen/datewise_expense_screen.dart';
import 'package:expense_tracker_with_node/api_calls/expense_caller.dart';
import 'package:expense_tracker_with_node/api_calls/login_and_signup.dart';
import 'package:expense_tracker_with_node/river_pod/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerHome extends ConsumerWidget {
  const DrawerHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final imageUrl = user!['coverImage'];

    return Drawer(
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

          SizedBox(height: 10),

          ListTile(
            title: Text("change CoverImage"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangeImageScreen()),
              );
            },
            leading: Icon(Icons.edit),
          ),

          ListTile(
            title: Text("change password"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
              );
            },
            leading: Icon(Icons.edit),
          ),

          ListTile(
            title: Text("Get Datewise Expense"),
            onTap: () async {
              final DateTimeRange? dateRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                currentDate: DateTime.now(),
              );

              if (dateRange != null) {
                final startDate = dateRange.start;
                final endDate = dateRange.end;

                // Fetch data based on selected date range
                await ExpenseCaller.dateWiseExpense(
                  ref: ref,
                  startDate: startDate,
                  endDate: endDate,
                );

                // Navigate to the DateWiseExpenseScree

                if (!context.mounted) return;

                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DateWiseExpenseScreen(),
                  ),
                );
              }
            },
            leading: Icon(Icons.edit_calendar),
          ),

          ListTile(
            title: Text("Log out"),
            onTap: () async {
              await ApiAuthentication.logout(context: context, ref: ref);
            },
            leading: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
