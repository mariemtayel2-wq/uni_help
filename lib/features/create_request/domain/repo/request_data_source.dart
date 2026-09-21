import 'dart:io';

import 'package:uni_help/features/create_request/data/model/create_request_dto.dart';

abstract class CreateRequestRemoteDataSource {
  Future<void> createRequest(CreateRequestModel requestModel, File? attachment);
}