import 'package:dio/dio.dart';
import 'package:expense_tracker_with_node/dio_function.dart';
import 'package:expense_tracker_with_node/river_pod/datawise_expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseCaller {
  static Future<Map<String, dynamic>> showExpense({String? cursor}) async {
    try {
      final response = await dio.get(
        "/user/showExpense",
        queryParameters: {
          //if (cursor != null)
          'cursor': cursor,
        },
      );
      final data = response.data;

      print("status code${response.statusCode}");
      print(" cursor check $cursor");

      if (response.statusCode == 200) {
        return data;
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to fetch expenses',
        };
      }
    } on DioException catch (e) {
      return {'success': false, 'message': 'Something went wrong: $e'};
    }
  }

  static Future<void> dateWiseExpense({
    required WidgetRef ref,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await dio.get(
        "/user/getDateWiseExpense",
        queryParameters: {"startDate": startDate, "endDate": endDate},
      );

      final data = response.data;

      if (response.statusCode == 200) {
        data['message'] = null;

        ref.read(dateWiseExpenseProvider.notifier).state = data;
      } else {
        ref.read(dateWiseExpenseProvider.notifier).state = {
          "message": data['message'],
        };
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'something went wrong';
      ref.read(dateWiseExpenseProvider.notifier).state = {
        "message": errorMessage,
      };
    }
  }
}
