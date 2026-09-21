
import 'dart:io';
import 'package:uni_help/features/create_request/domain/entity/request_entity.dart';

abstract class CreateRequestRepository {
  Future<void> createRequest(RequestEntity request, File? attachment);
}