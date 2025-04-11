import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:expense_tracker_with_node/Screen/home_screen.dart';
import 'package:expense_tracker_with_node/dio_function.dart';
import 'package:expense_tracker_with_node/river_pod/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiAuthentication {
  static Future<void> loginUser({
    required BuildContext context,
    required WidgetRef ref,
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
        ref.read(userProvider.notifier).state = data['user'];

        final SharedPreferences pref = await SharedPreferences.getInstance();

        final userJson = jsonEncode(data['user']);
        await pref.setString("user", userJson);

        if (!context.mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
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
    //required BuildContext context,
    required State state,
    required String userName,
    required String email,
    required String password,
    required ValueNotifier<String?> imagePathNotifier,
  }) async {
    final messager = ScaffoldMessenger.of(state.context);
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

      if (!state.mounted) return;
      final data = response.data;

      if (response.statusCode == 201) {
        print(data['user']);
        messager.showSnackBar(
          const SnackBar(
            content: Text("user created"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(state.context);
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
