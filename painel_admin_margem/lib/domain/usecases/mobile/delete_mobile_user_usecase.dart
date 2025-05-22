// domain/usecases/mobile/delete_mobile_user_usecase.dart
import 'package:dartz/dartz.dart';
import '../../repositories/i_mobile_repository.dart';
import '../../../core/error/failures.dart';

class DeleteMobileUserUseCase {
  final IMobileRepository repository;

  DeleteMobileUserUseCase({required this.repository});

  Future<Either<Failure, void>> call(String id) async {
    return repository.deleteMobileUser(id);
  }
}
