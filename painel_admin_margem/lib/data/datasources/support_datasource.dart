import 'package:dio/dio.dart';
import '../models/support/support_model.dart';
import '../models/support/support_request.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/api_client.dart';

abstract class SupportDataSource {
  Future<List<SupportModel>> getSupportUsers();
  Future<SupportModel> getSupportUserById(String id);
  Future<SupportModel> getSupportUserByEmail(String email);
  Future<SupportModel> createSupportUser(SupportRequest user);
  Future<SupportModel> updateSupportUser(String id, SupportRequest user);
  Future<void> deleteSupportUser(String id);
  Future<List<Map<String, dynamic>>> getPartners();
}

class SupportDataSourceImpl implements SupportDataSource {
  final ApiClient client;

  SupportDataSourceImpl({required this.client});

  @override
  Future<List<SupportModel>> getSupportUsers() async {
    try {
      final response = await client.get('/admin/support');

      if (response.statusCode == 200) {
        if (response.data is List) {
          return (response.data as List)
              .map((json) => SupportModel.fromJson(json))
              .toList();
        } else {
          return [];
        }
      } else {
        throw ServerException(
          message: 'Falha ao obter usuários de suporte',
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
  Future<SupportModel> getSupportUserById(String id) async {
    try {
      final response =
          await client.get('/admin/support', queryParameters: {'id': id});

      if (response.statusCode == 200) {
        return SupportModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Falha ao obter usuário de suporte',
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
  Future<SupportModel> getSupportUserByEmail(String email) async {
    try {
      final response =
          await client.get('/admin/support', queryParameters: {'email': email});

      if (response.statusCode == 200) {
        return SupportModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Falha ao obter usuário de suporte',
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
  Future<SupportModel> createSupportUser(SupportRequest user) async {
    try {
      final response = await client.post(
        '/admin/support',
        data: user.toJson(),
      );

      if (response.statusCode == 200) {
        return SupportModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Falha ao criar usuário de suporte',
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
  Future<SupportModel> updateSupportUser(String id, SupportRequest user) async {
    try {
      final response = await client.put(
        '/admin/support',
        queryParameters: {'id': id},
        data: user.toJson(),
      );

      if (response.statusCode == 200) {
        return SupportModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Falha ao atualizar usuário de suporte',
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
  Future<void> deleteSupportUser(String id) async {
    try {
      final response = await client.delete(
        '/admin/support',
        queryParameters: {'id': id},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Falha ao excluir usuário de suporte',
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
  Future<List<Map<String, dynamic>>> getPartners() async {
    try {
      final response = await client.get('/admin/partners');

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((item) => {
                  'name': item['name'] as String,
                  'code': item['code'] as double,
                })
            .toList();
      } else {
        throw ServerException(
          message: 'Falha ao obter parceiros',
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
