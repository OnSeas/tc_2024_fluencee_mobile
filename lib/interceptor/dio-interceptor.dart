import 'package:dio/dio.dart';
import 'package:tc_2024_fluencee_mobile/api/api-service.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await ApiService.getTokenUsuarioLogado();

    if (token != null &&
        token.isNotEmpty &&
        options.path != '/login' &&
        options.path != '/cadastrar') {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}
