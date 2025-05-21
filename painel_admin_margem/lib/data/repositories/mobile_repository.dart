import 'package:dartz/dartz.dart';
import '../../domain/entities/mobile_user.dart';
import '../../domain/entities/store.dart';
import '../../domain/repositories/i_mobile_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';
import '../datasources/mobile_datasource.dart';
import '../models/mobile/mobile_model.dart';
import '../models/mobile/mobile_request.dart';
import '../models/store/store_model.dart';

class MobileRepository implements IMobileRepository {
  final MobileDataSource dataSource;
  final NetworkInfo networkInfo;

  MobileRepository({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MobileUser>>> getMobileUsers() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final users = await dataSource.getMobileUsers();
      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MobileUser>> getMobileUserById(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final user = await dataSource.getMobileUserById(id);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MobileUser>> getMobileUserByEmail(String email) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final user = await dataSource.getMobileUserByEmail(email);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MobileUser>> createMobileUser(MobileUser user) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final userModel = MobileModel.fromEntity(user);
      final userRequest = MobileRequest.fromModel(userModel);
      final createdUser = await dataSource.createMobileUser(userRequest);
      return Right(createdUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MobileUser>> updateMobileUser(MobileUser user) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final userModel = MobileModel.fromEntity(user);
      final userRequest = MobileRequest.fromModel(userModel);
      final updatedUser =
          await dataSource.updateMobileUser(user.id, userRequest);
      return Right(updatedUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMobileUser(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      await dataSource.deleteMobileUser(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Store>>> getMobileUserStores(
      String userId) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final storesData = await dataSource.getMobileUserStores(userId);
      final stores =
          storesData.map((json) => StoreModel.fromJson(json)).toList();
      return Right(stores);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> linkStoreToMobileUser(
      String userId, String storeId) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      await dataSource.linkStoreToMobileUser(userId, storeId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unlinkStoreFromMobileUser(
      String userId, String storeId) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      await dataSource.unlinkStoreFromMobileUser(userId, storeId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
