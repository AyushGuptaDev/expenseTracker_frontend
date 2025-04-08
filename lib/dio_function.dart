import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

late final Dio dio;

Future<void> setupDio() async {
  final Directory appDoDir = await getApplicationDocumentsDirectory();

  final String cookiePath = "${appDoDir.path}/.cookies/";

  final String baseurl = dotenv.env['BASE_URL']!;
  print("dotenvUrl  $baseurl");

  final cookieJar = PersistCookieJar(
    storage: FileStorage(cookiePath),
    ignoreExpires: true,
  );

  dio =
      Dio()
        ..options.baseUrl = baseurl
        ..options.headers['Content-Type'] = 'application/json'
        ..interceptors.add(CookieManager(cookieJar));
}
