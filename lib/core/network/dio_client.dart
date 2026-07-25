import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class DioClient {
  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: const {
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (ApiConstants.apiKey.isEmpty) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.unknown,
                message: 'NEWS_API_KEY is missing.',
              ),
            );
            return;
          }

          options.headers['X-Api-Key'] = ApiConstants.apiKey;
          handler.next(options);
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(
        requestHeader: false,
        responseHeader: false,
        requestBody: false,
        responseBody: false,
        error: true,
      ),
    );
  }

  late final Dio dio;
}
