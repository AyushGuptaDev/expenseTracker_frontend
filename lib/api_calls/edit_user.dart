import 'package:dio/dio.dart';
import 'package:expense_tracker_with_node/dio_function.dart';
import 'package:expense_tracker_with_node/river_pod/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditUser {
  static Future<void> changePassword({
    required BuildContext context,
    required String prevPassword,
    required String updatedPassword,
  }) async {
    final meassger = ScaffoldMessenger.of(context);
    try {
      final response = await dio.post(
        "/user/changePassword",
        data: {
          'prevPassword': prevPassword,
          'updatedPassword': updatedPassword,
        },
      );

      if (!context.mounted) return;

      final data = response.data;
      if (response.statusCode == 200) {
        meassger.showSnackBar(
          SnackBar(
            content: Text(data['message']),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } else {
        meassger.showSnackBar(
          SnackBar(content: Text(data['message']), backgroundColor: Colors.red),
        );
      }
    } on DioException catch (e) {
      meassger.showSnackBar(
        SnackBar(
          content: Text(
            "Failed: ${e.response?.data['message'] ?? 'Unknown error'}",
          ),
        ),
      );
    }
  }

  static Future<void> changeCoverImage({
    required WidgetRef ref,
    required BuildContext context,
    required ValueNotifier<String?> imagePathNotifier,
  }) async {
    final massager = ScaffoldMessenger.of(context);
    try {
      final formData = FormData.fromMap({
        if (imagePathNotifier.value != null)
          "coverImage": imagePathNotifier.value,
      });

      final response = await dio.post('/user/changeCoverImage', data: formData);

      final data = response.data;

      if (!context.mounted) return;

      if (response.statusCode == 200) {
        ref.read(userProvider.notifier).state = {
          ...ref.read(userProvider)!,
          "coverImage": data['coverImage'],
        };

        massager.showSnackBar(
          SnackBar(
            content: Text("image changed successfully"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } else {
        massager.showSnackBar(
          SnackBar(content: Text(data['message']), backgroundColor: Colors.red),
        );
      }
    } on DioException catch (e) {
      massager.showSnackBar(
        SnackBar(
          content: Text(
            "Failed: ${e.response?.data['message'] ?? 'Unknown error'}",
          ),
        ),
      );
    }
  }
}
