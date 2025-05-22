// domain/usecases/support/update_support_user_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/support_user.dart';
import '../../repositories/i_support_repository.dart';
import '../../../core/error/failures.dart';

class UpdateSupportUserUseCase {
  final ISupportRepository repository;

  UpdateSupportUserUseCase({required this.repository});

  Future<Either<Failure, SupportUser>> call(SupportUser user) async {
    return repository.updateSupportUser(user);
  }
}
