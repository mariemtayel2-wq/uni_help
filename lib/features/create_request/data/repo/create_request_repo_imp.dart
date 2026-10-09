import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:uni_help/core/entities/request_entity.dart';
import 'package:uni_help/core/model/request_dto.dart';
import 'package:uni_help/features/create_request/domain/repo/request_data_source.dart';
import 'package:uni_help/features/create_request/domain/repo/request_repo.dart';

@Injectable(as: CreateRequestRepository)
class CreateRequestRepositoryImpl implements CreateRequestRepository {
  final CreateRequestRemoteDataSource remoteDataSource;

  CreateRequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> createRequest(RequestEntity request, File? attachment) async {
    try {
      final requestModel = RequestModel.fromEntity(request);

      return await remoteDataSource.createRequest(requestModel, attachment);
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }
}
