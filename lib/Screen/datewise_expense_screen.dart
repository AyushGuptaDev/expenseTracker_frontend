import 'package:expense_tracker_with_node/river_pod/datawise_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateWiseExpenseScreen extends ConsumerWidget {
  const DateWiseExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final data = ref.watch(dateWiseExpenseProvider);
    final expenses = data['expenses'] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text("Date Wise Expense")),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors
                              .grey
                              .shade800 // Dark gray for dark mode
                          : Colors.grey.shade300, // Light gray for light mode
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text("Total Amount", style: TextStyle(fontSize: 20)),

                      Spacer(),

                      Text(
                        "₹ ${data['totalAmount']}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 5),

            Expanded(
              child:
                  expenses.isEmpty
                      ? Center(child: Text('No expenses found.'))
                      : ListView.builder(
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenses[index];

                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              bottom: 10,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      isDarkMode
                                          ? Colors.grey.shade700
                                          : Colors.grey.shade300,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(expense['title'] ?? 'No Title'),
                                subtitle: Text("Amount: ₹${expense['amount']}"),
                                leading: Icon(Icons.money),
                                onTap: () {
                                  // Add any action when tapping on an expense item
                                },
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
