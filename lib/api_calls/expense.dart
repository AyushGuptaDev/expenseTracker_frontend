import 'package:dio/dio.dart';
import 'package:expense_tracker_with_node/dio_function.dart';
import 'package:expense_tracker_with_node/river_pod/expenses_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Expense {
  static Future<void> addExpense({
    required BuildContext context,
    required WidgetRef ref,
    required final int amount,
    required final String title,
  }) async {
    final messager = ScaffoldMessenger.of(context);
    try {
      final titleTrim = title.trim();
      final response = await dio.post(
        "/user/expense/addExpense",
        data: {'amount': amount, if (titleTrim != '') 'title': titleTrim},
      );
      final data = response.data;

      if (response.statusCode == 200) {
        ref.read(expensesProvider.notifier).addExpense(data['expense']);

        messager.showSnackBar(
          SnackBar(
            content: Text("Expense added"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        messager.showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "error occurred Try again"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on DioException catch (e) {
      messager.showSnackBar(
        SnackBar(
          content: Text(
            "Failed: ${e.response?.data['message'] ?? 'Unknown error'}",
          ),
        ),
      );
    }
  }

  static Future<void> deleteExpense({
    required BuildContext context,
    required WidgetRef ref,
    required String expenseId,
  }) async {
    final messanger = ScaffoldMessenger.of(context);

    final response = await dio.post(
      "/user/expense/deleteExpense",
      data: {"expenseId": expenseId},
    );

    final data = response.data;

    if (response.statusCode == 200) {
      ref.read(expensesProvider.notifier).deleteExpense(expenseId);

      messanger.showSnackBar(SnackBar(content: Text(data['message'])));
    } else {
      messanger.showSnackBar(SnackBar(content: Text(data['message'])));
    }
  }
}
