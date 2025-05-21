import 'package:dio/dio.dart';
import '../models/store/store_model.dart';
import '../models/store/store_request.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/api_client.dart';

abstract class StoreDataSource {
  Future<List<StoreModel>> getStores({String? cnpj, String? id});
  Future<StoreModel> getStoreById(String id);
  Future<StoreModel> getStoreByCnpj(String cnpj);
  Future<StoreModel> createStore(StoreRequest store);
  Future<StoreModel> updateStore(String id, StoreRequest store);
  Future<void> deleteStore(String id);
  Future<List<String>> getSegments();
  Future<List<String>> getSizes();
  Future<List<Map<String, dynamic>>> getStates();
  Future<List<Map<String, dynamic>>> getPartners();
}

class StoreDataSourceImpl implements StoreDataSource {
  final ApiClient client;

  StoreDataSourceImpl({required this.client});

  @override
  Future<List<StoreModel>> getStores({String? cnpj, String? id}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (cnpj != null) queryParams['cnpj'] = cnpj;
      if (id != null) queryParams['id'] = id;

      final response =
          await client.get('/admin/store', queryParameters: queryParams);

      if (response.statusCode == 200) {
        if (response.data is List) {
          return (response.data as List)
              .map((json) => StoreModel.fromJson(json))
              .toList();
        } else if (response.data != null && id != null) {
          // Se estamos buscando por ID e recebemos um único objeto
          return [StoreModel.fromJson(response.data)];
        } else {
          return [];
        }
      } else {
        throw ServerException(
          message: 'Falha ao obter lojas',
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
  Future<StoreModel> getStoreById(String id) async {
    try {
      final response =
          await client.get('/admin/store', queryParameters: {'id': id});

      if (response.statusCode == 200) {
        return StoreModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Loja não encontrada',
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
  Future<StoreModel> getStoreByCnpj(String cnpj) async {
    try {
      final response =
          await client.get('/admin/store', queryParameters: {'cnpj': cnpj});

      if (response.statusCode == 200) {
        if (response.data is List && (response.data as List).isNotEmpty) {
          return StoreModel.fromJson((response.data as List).first);
        } else if (response.data != null && !(response.data is List)) {
          return StoreModel.fromJson(response.data);
        } else {
          throw ServerException(
            message: 'Loja não encontrada',
            statusCode: 404,
          );
        }
      } else {
        throw ServerException(
          message: 'Falha ao buscar loja por CNPJ',
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
  Future<StoreModel> createStore(StoreRequest store) async {
    try {
      final response = await client.post(
        '/admin/store',
        data: store.toJson(),
      );

      if (response.statusCode == 200) {
        return StoreModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Falha ao criar loja',
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
  Future<StoreModel> updateStore(String id, StoreRequest store) async {
    try {
      final response = await client.put(
        '/admin/store',
        queryParameters: {'id': id},
        data: store.toJson(),
      );

      if (response.statusCode == 200) {
        return StoreModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Falha ao atualizar loja',
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
  Future<void> deleteStore(String id) async {
    try {
      final response = await client.delete(
        '/admin/store',
        queryParameters: {'id': id},
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Falha ao excluir loja',
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
  Future<List<String>> getSegments() async {
    try {
      final response = await client.get('/admin/segments');

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((item) => item['description'] as String)
            .toList();
      } else {
        throw ServerException(
          message: 'Falha ao obter segmentos',
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
  Future<List<String>> getSizes() async {
    try {
      final response = await client.get('/admin/sizes');

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((item) => item['value'] as String)
            .toList();
      } else {
        throw ServerException(
          message: 'Falha ao obter tamanhos',
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
  Future<List<Map<String, dynamic>>> getStates() async {
    try {
      final response = await client.get('/admin/states');

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((item) => {
                  'name': item['name'] as String,
                  'code': item['code'] as String,
                })
            .toList();
      } else {
        throw ServerException(
          message: 'Falha ao obter estados',
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
