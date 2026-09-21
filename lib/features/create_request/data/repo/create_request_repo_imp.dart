import 'dart:io';

import 'package:uni_help/features/create_request/data/model/create_request_dto.dart';
import 'package:uni_help/features/create_request/domain/entity/request_entity.dart';
import 'package:uni_help/features/create_request/domain/repo/request_data_source.dart';
import 'package:uni_help/features/create_request/domain/repo/request_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CreateRequestRepository)
class CreateRequestRepositoryImpl implements CreateRequestRepository {
  final CreateRequestRemoteDataSource remoteDataSource;

  CreateRequestRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<void> createRequest(
    RequestEntity request,
    File? attachment,
  ) async {
    try {
      final requestModel = CreateRequestModel.fromEntity(request);

      await remoteDataSource.createRequest(
        requestModel,
        attachment,
      );
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }
}