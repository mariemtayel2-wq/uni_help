import 'dart:io';

import 'package:uni_help/core/model/request_dto.dart';


abstract class CreateRequestRemoteDataSource {
  Future<String> createRequest(RequestModel requestModel, File? attachment);
}