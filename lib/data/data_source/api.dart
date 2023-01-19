import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_poetry/data/routeApi.dart';
import 'package:flutter_poetry/tool/extension.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class Api {
  static late Api _instance;

  Api._internal();

  static Api getInstance() {
    _instance = Api._internal();
    return _instance;
  }

  BaseOptions options = BaseOptions(
    baseUrl: RouteApi.baseUrl,
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  Dio dio() {
    Dio dio = Dio(options);
    // dio.interceptors.add(PrettyDioLogger(
    //   requestHeader: true,
    //   requestBody: true,
    //   responseBody: true,
    //   responseHeader: false,
    //   compact: false,
    // ));
    return dio;
  }

  get<T>(String url,
      {Function(Map<String, dynamic>)? success,
        Function(Object)? error}) async {
    try {
      var response = await dio().get(url);
      var json = decodeJson(response);
      success!(json);
    } catch (e) {
      myLog("error url: ${e.toString()}");
      myLog("error ${e.toString()}");
      error!(e);
    }
  }

  getArray<T>(String url,
      {Function(List<dynamic>)? success,
        Function(Object)? error}) async {
    try {
      var response = await dio().get(url);
      var json = decodeJson(response);
      await success!(json['data']);
    } catch (e) {
      myLog("error url: ${e.toString()}");
      myLog("error ${e.toString()}");
      error!(e);
    }
  }

  //解析json檔
  static decodeJson(Response response) {
    return jsonDecode(response.toString());
  }
}
