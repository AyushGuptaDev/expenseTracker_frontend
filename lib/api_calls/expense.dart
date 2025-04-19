import 'package:dio/dio.dart';
import 'package:expense_tracker_with_node/dio_function.dart';
import 'package:flutter/material.dart';

class Expense {
  static Future<void> addExpense({
    required BuildContext context,
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
}
