import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lead_entity.dart';
import '../repositories/project_repository.dart';

class GetAvailableLeadsUseCase {
  final ProjectRepository repository;

  GetAvailableLeadsUseCase(this.repository);

  Future<Either<Failure, List<LeadEntity>>> call(String department) async {
    if (department.isEmpty) {
      return const Left(ValidationFailure('Department cannot be empty'));
    }

    return await repository.getAvailableLeads(department);
  }
}