// domain/usecases/support/get_support_users_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/support_user.dart';
import '../../repositories/i_support_repository.dart';
import '../../../core/error/failures.dart';

class GetSupportUsersUseCase {
  final ISupportRepository repository;

  GetSupportUsersUseCase({required this.repository});

  Future<Either<Failure, List<SupportUser>>> call() async {
    return repository.getSupportUsers();
  }
}
