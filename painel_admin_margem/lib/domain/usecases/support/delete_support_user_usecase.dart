// domain/usecases/support/delete_support_user_usecase.dart
import 'package:dartz/dartz.dart';
import '../../repositories/i_support_repository.dart';
import '../../../core/error/failures.dart';

class DeleteSupportUserUseCase {
  final ISupportRepository repository;

  DeleteSupportUserUseCase({required this.repository});

  Future<Either<Failure, void>> call(String id) async {
    return repository.deleteSupportUser(id);
  }
}
