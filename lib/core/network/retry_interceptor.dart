import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  RetryInterceptor(this.dio, {this.maxRetries = 3});

  bool _shouldRetry(DioException err) {
    final code = err.response?.statusCode ?? 0;
    return err.type == DioExceptionType.connectionError ||
           code == 429 || code >= 500;
  }

  Duration _delay(int attempt) => Duration(milliseconds: 300 * (1 << (attempt - 1)));

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    final attempt = (err.requestOptions.extra['retry'] as int? ?? 0) + 1;
    if (attempt <= maxRetries && _shouldRetry(err)) {
      await Future.delayed(_delay(attempt));
      final req = err.requestOptions..extra['retry'] = attempt;
      try {
        final res = await dio.fetch(req);
        return handler.resolve(res);
      } catch (e) {
        return super.onError(err, handler);
      }
    }
    return super.onError(err, handler);
  }
}
