import 'package:dio/dio.dart';
import '../models/mobile/mobile_model.dart';
import '../models/mobile/mobile_request.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/api_client.dart';

abstract class MobileDataSource {
  Future<List<MobileModel>> getMobileUsers();
  Future<MobileModel> getMobileUserById(String id);
  Future<MobileModel> getMobileUserByEmail(String email);
  Future<MobileModel> createMobileUser(MobileRequest user);
  Future<MobileModel> updateMobileUser(String id, MobileRequest user);
  Future<void> deleteMobileUser(String id);
  Future<List<Map<String, dynamic>>> getMobileUserStores(String userId);
  Future<void> linkStoreToMobileUser(String userId, String storeId);
  Future<void> unlinkStoreFromMobileUser(String userId, String storeId);
}

class MobileDataSourceImpl implements MobileDataSource {
  final ApiClient client;

  MobileDataSourceImpl({required this.client});

  @override
  Future<List<MobileModel>> getMobileUsers() async {
    try {
      final response = await client.get('/admin/mobile');

      if (response.statusCode == 200) {
        if (response.data is List) {
          return (response.data as List)
              .map((json) => MobileModel.fromJson(json))
              .toList();
        } else {
          return [];
        }
      } else {
        throw ServerException(
          message: 'Falha ao obter usuários mobile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Erro de conexão',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MobileModel> getMobileUserById(String id) async {
    try {
      final response =
          await client.get('/admin/mobile', queryParameters: {'id': id});

      if (response.statusCode == 200) {
        return MobileModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Usuário mobile não encontrado',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Erro de conexão',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MobileModel> getMobileUserByEmail(String email) async {
    try {
      final response =
          await client.get('/admin/mobile', queryParameters: {'email': email});

      if (response.statusCode == 200) {
        return MobileModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Usuário mobile não encontrado',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Erro de conexão',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MobileModel> createMobileUser(MobileRequest user) async {
    try {
      final response = await client.post(
        '/admin/mobile',
        data: user.toJson(),
      );

      if (response.statusCode == 200) {
        return MobileModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Falha ao criar usuário mobile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Erro de conexão',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MobileModel> updateMobileUser(String id, MobileRequest user) async {
    try {
      final response = await client.put(
        '/admin/mobile',
        queryParameters: {'id': id},
        data: user.toJson(),
      );

      if (response.statusCode == 200) {
        return MobileModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Falha ao atualizar usuário mobile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Erro de conexão',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteMobileUser(String id) async {
    try {
      final response = await client.delete(
        '/admin/mobile',
        queryParameters: {'id': id},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Falha ao excluir usuário mobile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Erro de conexão',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMobileUserStores(String userId) async {
    try {
      final response = await client.get(
        '/admin/mobile/store',
        queryParameters: {'id': userId},
      );

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((json) => json as Map<String, dynamic>)
            .toList();
      } else {
        throw ServerException(
          message: 'Falha ao obter lojas do usuário mobile',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Erro de conexão',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> linkStoreToMobileUser(String userId, String storeId) async {
    try {
      final response = await client.post(
        '/admin/mobile/store',
        queryParameters: {'id': userId},
        data: {'storeId': storeId},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Falha ao vincular loja ao usuário',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Erro de conexão',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> unlinkStoreFromMobileUser(String userId, String storeId) async {
    try {
      final response = await client.delete(
        '/admin/mobile/store',
        queryParameters: {'id': userId, 'storeId': storeId},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Falha ao desvincular loja do usuário',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'Erro de conexão',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
