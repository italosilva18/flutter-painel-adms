import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cliente para chamadas à API
class ApiClient {
  final Dio _dio;
  static const String _tokenKey = 'auth_token';

  ApiClient(this._dio) {
    _dio.options.baseUrl =
        dotenv.env['API_BASE_URL'] ?? 'https://api.painelmargem.com.br';
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );
  }

  /// Interceptador para adicionar token de autenticação às requisições
  Future<void> _onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!options.path.contains('/login')) {
      final token = await getToken();
      if (token != null) {
        options.headers['Authorization'] = token;
      }
    }
    handler.next(options);
  }

  /// Interceptador para tratamento de erros
  Future<void> _onError(
      DioException error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 401) {
      // Token expirado ou inválido
      await clearToken();
      // Pode-se adicionar um callback para redirecionar para a tela de login
    }
    handler.next(error);
  }

  /// Configura o token após o login
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Obtém o token armazenado
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Remove o token (logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Verifica se o usuário está autenticado
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  /// Realiza requisição GET
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  /// Realiza requisição POST
  Future<Response> post(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.post(path, data: data, queryParameters: queryParameters);
  }

  /// Realiza requisição PUT
  Future<Response> put(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _dio.put(path, data: data, queryParameters: queryParameters);
  }

  /// Realiza requisição DELETE
  Future<Response> delete(String path,
      {Map<String, dynamic>? queryParameters}) {
    return _dio.delete(path, queryParameters: queryParameters);
  }

  /// Método para fazer login
  Future<Response> login(String email, String password) {
    return post('/admin/login', data: {
      'email': email,
      'password': password,
    });
  }
}
