import 'package:dartz/dartz.dart';
import '../../domain/entities/support_user.dart';
import '../../domain/repositories/i_support_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';
import '../datasources/support_datasource.dart';
import '../models/support/support_model.dart';
import '../models/support/support_request.dart';

class SupportRepository implements ISupportRepository {
  final SupportDataSource dataSource;
  final NetworkInfo networkInfo;

  SupportRepository({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SupportUser>>> getSupportUsers() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final users = await dataSource.getSupportUsers();
      return Right(users.cast<SupportUser>());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupportUser>> getSupportUserById(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await dataSource.getSupportUserById(id);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupportUser>> getSupportUserByEmail(
      String email) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await dataSource.getSupportUserByEmail(email);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupportUser>> createSupportUser(
      SupportUser user) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final userModel = SupportModel.fromEntity(user);
      final userRequest = SupportRequest.fromModel(userModel);
      final createdUser = await dataSource.createSupportUser(userRequest);
      return Right(createdUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupportUser>> updateSupportUser(
      SupportUser user) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final userModel = SupportModel.fromEntity(user);
      final userRequest = SupportRequest.fromModel(userModel);
      final updatedUser =
          await dataSource.updateSupportUser(user.id, userRequest);
      return Right(updatedUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSupportUser(String id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await dataSource.deleteSupportUser(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getPartners() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final partners = await dataSource.getPartners();
      return Right(partners);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
