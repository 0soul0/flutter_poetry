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

  getReturn<T>(String url, {Function(Object)? error}) async {
    try {
      var response = await dio().get(url);
      return decodeJson(response);
    } catch (e) {
      myLog("error url: $url");
      myLog("error ${e.toString()}");
      error!(e);
      return null;
    }
  }

  get<T>(String url,
      {Function(Map<String, dynamic>)? success,
      Function(Object)? error}) async {
    try {
      var response = await dio().get(url);
      var json = decodeJson(response);
      success!(json);
    } catch (e) {
      myLog("error url: $url");
      myLog("error ${e.toString()}");
      error!(e);
    }
  }

  getArrayReturn<T>(String url, {Function(Object)? error}) async {
    try {
      var response = await dio().get(url);
      var json = decodeJson(response);
      return json['data'];
    } catch (e) {
      myLog("error url: $url");
      myLog("error ${e.toString()}");
      error!(e);
      return null;
    }
  }

  getArray<T>(String url,
      {Function(List<dynamic>)? success, Function(Object)? error}) async {
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
    return json.decode(response.data);
  }
}
