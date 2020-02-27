import 'package:dio/dio.dart';

class DioHelper {
  static String host = "http://192.168.0.3:5000";
  Dio dio;
  DioHelper() {
    dio = Dio(
        BaseOptions(baseUrl: host, connectTimeout: 500000, receiveTimeout: 3000000));
  }
}
