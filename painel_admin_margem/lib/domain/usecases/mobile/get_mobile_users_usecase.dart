// domain/usecases/mobile/get_mobile_users_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/mobile_user.dart';
import '../../repositories/i_mobile_repository.dart';
import '../../../core/error/failures.dart';

class GetMobileUsersUseCase {
  final IMobileRepository repository;

  GetMobileUsersUseCase({required this.repository});

  Future<Either<Failure, List<MobileUser>>> call() async {
    return repository.getMobileUsers();
  }
}
