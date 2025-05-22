import 'dart:convert';
import '../models/auth/auth_request.dart';
import '../models/auth/user_model.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Interface para fonte de dados de autenticação
abstract class AuthDataSource {
  /// Realiza o login do usuário
  Future<UserModel> login(LoginRequest request);

  /// Realiza o logout do usuário
  Future<void> logout();

  /// Verifica se o usuário está autenticado
  Future<bool> isAuthenticated();

  /// Obtém o usuário atual
  Future<UserModel?> getCurrentUser();

  /// Salva o usuário na cache local
  Future<void> cacheUser(UserModel user);

  /// Remove o usuário da cache local
  Future<void> clearUserCache();
}

/// Implementação concreta da fonte de dados de autenticação
class AuthDataSourceImpl implements AuthDataSource {
  final ApiClient client;
  final SharedPreferences sharedPreferences;

  static const String _cachedUserKey = 'CACHED_USER';

  AuthDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  @override
  Future<UserModel> login(LoginRequest request) async {
    try {
      final response = await client.login(request.email, request.password);

      final loginResponse = LoginResponse.fromJson(response.data);

      // Gera ID interno pois a API não retorna
      final userId = DateTime.now().millisecondsSinceEpoch.toString();

      final user = UserModel(
        id: userId,
        name: loginResponse.name,
        email: loginResponse.email,
        token: loginResponse.token,
      );

      // Salva o token no ApiClient
      await client.setToken(loginResponse.token);

      // Salva o usuário localmente
      await cacheUser(user);

      return user;
    } catch (e) {
      throw AuthenticationException(
        message: 'Falha no login: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Limpa o token no ApiClient
      await client.clearToken();

      // Limpa o usuário da cache
      await clearUserCache();
    } catch (e) {
      throw CacheException(
        message: 'Falha ao realizar logout: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      return await client.isAuthenticated();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final jsonString = sharedPreferences.getString(_cachedUserKey);
      if (jsonString != null) {
        return UserModel.fromJson(
          Map<String, dynamic>.from(
            jsonDecode(jsonString),
          ),
        );
      }
      return null;
    } catch (e) {
      throw CacheException(
        message: 'Falha ao obter usuário atual: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final jsonString = jsonEncode(user.toJson());
      await sharedPreferences.setString(_cachedUserKey, jsonString);
    } catch (e) {
      throw CacheException(
        message: 'Falha ao salvar usuário: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> clearUserCache() async {
    try {
      await sharedPreferences.remove(_cachedUserKey);
    } catch (e) {
      throw CacheException(
        message: 'Falha ao limpar cache de usuário: ${e.toString()}',
      );
    }
  }
}
