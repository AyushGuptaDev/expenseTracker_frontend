import 'package:dio/dio.dart';
import 'package:expense_tracker_with_node/dio_function.dart';
import 'package:flutter/material.dart';

class ApiAuthentication {
  static Future<void> loginUser(
    BuildContext context,
    String emailOrUsername,
    String password,
  ) async {
    final messager = ScaffoldMessenger.of(context);
    try {
      final bool isEmail = emailOrUsername.contains('@');
      final response = await dio.post(
        '/user/login',
        data:
            isEmail
                ? {'email': emailOrUsername, 'password': password}
                : {'userName': emailOrUsername, 'password': password},
      );
      final data = response.data;
      if (response.statusCode == 200) {
        print(data);
        messager.showSnackBar(
          const SnackBar(
            content: Text("Login Successful"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        messager.showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "something went wrong"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on DioException catch (e) {
      print(e.response?.data);

      messager.showSnackBar(
        SnackBar(
          content: Text(
            "Login failed: ${e.response?.data['message'] ?? 'Unknown error'}",
          ),
        ),
      );
    }
  }
}
