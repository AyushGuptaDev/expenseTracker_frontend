import 'package:expense_tracker_with_node/api_calls/expense.dart';
import 'package:flutter/material.dart';

class ExpenseAdder {
  static void showBottomSheet(BuildContext context) {
    final amountController = TextEditingController();
    final titleController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 8,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin: EdgeInsets.only(bottom: 20),
                ),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(hintText: "Expense Title"),
                ),
                SizedBox(height: 20),

                Row(
                  children: [
                    Icon(Icons.currency_rupee),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: "Amount"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 35,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final amount = int.tryParse(amountController.text);
                      Navigator.of(context).pop();
                      if (amount == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Please enter valid title and amount",
                            ),
                          ),
                        );
                        return;
                      }

                      await Expense.addExpense(
                        context: context,
                        amount: amount,
                        title: titleController.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text("Save Expense"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
