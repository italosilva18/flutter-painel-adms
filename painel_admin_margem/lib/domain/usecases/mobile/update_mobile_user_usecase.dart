// domain/usecases/mobile/update_mobile_user_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/mobile_user.dart';
import '../../repositories/i_mobile_repository.dart';
import '../../../core/error/failures.dart';

class UpdateMobileUserUseCase {
  final IMobileRepository repository;

  UpdateMobileUserUseCase({required this.repository});

  Future<Either<Failure, MobileUser>> call(MobileUser user) async {
    return repository.updateMobileUser(user);
  }
}
