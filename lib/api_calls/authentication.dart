import 'package:dio/dio.dart';
import 'package:expense_tracker_with_node/dio_function.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ApiAuthentication {
  static Future<void> loginUser({
    required BuildContext context,
    required String emailOrUsername,
    required String password,
  }) async {
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

  static Future<void> signUpUser({
    required BuildContext context,
    required String userName,
    required String email,
    required String password,
    required ValueNotifier<String?> imagePathNotifier,
  }) async {
    final messager = ScaffoldMessenger.of(context);
    try {
      final formData = FormData.fromMap({
        'userName': userName,
        'email': email,
        'password': password,
        if (imagePathNotifier.value != null) ...{
          'coverImage': await MultipartFile.fromFile(
            imagePathNotifier.value!,
            filename: basename(imagePathNotifier.value!),
          ),
        },
      });
      final response = await dio.post(
        '/user/signup',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      final data = response.data;
      if (response.statusCode == 201) {
        print(data['user']);
        messager.showSnackBar(
          const SnackBar(
            content: Text("user created"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        messager.showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "someThing went wrong"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on DioException catch (e) {
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
