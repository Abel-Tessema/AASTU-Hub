import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../config/dio_config.dart';

class DioService {
  static Future<void> dioPost({
    required String path,
    Options? options,
    Object? data,
    Function(Response)? onSuccess,
    Function(Object, Response)? onFailure,
  }) async {
    var response;
    try {
      response = await DioConfig.dio().post(path, options: options, data: data);
      Logger().d(response.data);
      if (onSuccess != null) onSuccess(response);
    } catch (e, stack) {
      Logger().d(path);
      Logger().t(e.toString(), stackTrace: stack);
      // print(response.data);
      print(e.toString());
      print(stack);
      if (onFailure != null) onFailure(e, response);
    }
  }

  static Future<void> dioPut({
    required String path,
    Options? options,
    Object? data,
    Function(Response)? onSuccess,
    Function(Object, Response)? onFailure,
  }) async {
    var response;
    try {
      response = await DioConfig.dio().put(path, options: options, data: data);
      print(response.data);
      if (onSuccess != null) onSuccess(response);
      Logger().d(response.data);
    } catch (e, stack) {
      Logger().d(path);
      Logger().t(e.toString(), stackTrace: stack);
      // print(response.data);
      print(e.toString());
      print(stack);
      if (onFailure != null) onFailure(e, response);
    }
  }

  static Future<void> dioGet({
    required String path,
    Options? options,
    Object? data,
    Function(Response)? onSuccess,
    Function(Object, Response)? onFailure,
  }) async {
    var response;
    try {
      response = await DioConfig.dio().get(path, options: options, data: data);
      // print(response.data);
      Logger().d(path);
      Logger().d(response.data);
      if (onSuccess != null) onSuccess(response);
    } catch (e, stack) {
      Logger().d(path);
      Logger().t(e.toString(), stackTrace: stack);
      // print(response.data);
      // print(e.toString());
      // print(stack);
      if (onFailure != null) onFailure(e, response);
    }
  }

  static Future<void> dioPostFormData({
    required String path,
    required FormData formData,
    Options? options,
    Function(Response)? onSuccess,
    Function(Object, Response)? onFailure,
  }) async {
    var response;
    try {
      response = await DioConfig.dio().post(
          'https://793b-102-213-68-99.ngrok-free.app/user/payment/verify-order-payment',
          data: formData,
          options: options);
      Logger().d(response.data);
      if (onSuccess != null) onSuccess(response);
    } catch (e, stack) {
      Logger().d(path);
      Logger().t(e.toString(), stackTrace: stack);
      // print(response?.data ?? 'No response');
      print(e.toString());
      print(stack);
      if (onFailure != null) onFailure(e, response);
    }
  }
}
