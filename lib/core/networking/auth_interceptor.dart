import 'package:dio/dio.dart';
import 'package:uni_help/core/storage_helper/scure_storage_helper.dart';

class AuthInterceptor extends Interceptor {

  final SecureStorageHelper storage;

  AuthInterceptor(this.storage);


  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {

    final token = await storage.getSecure(
      key: 'token',
    );


    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] =
          'Bearer $token';
    }


    handler.next(options);
  }
}