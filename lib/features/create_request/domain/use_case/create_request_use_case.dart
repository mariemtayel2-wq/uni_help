import 'dart:io';

import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/features/create_request/domain/repo/request_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CreateRequestUseCase {
  final CreateRequestRepository repository;

  CreateRequestUseCase(this.repository);

  Future<void> call(RequestEntity request, File? attachment) async {
    return await repository.createRequest(request, attachment);
  }
}