
import 'dart:io';
import 'package:uni_help/core/entities/request_entity.dart';

abstract class CreateRequestRepository {
  Future<String> createRequest(RequestEntity request, File? attachment);

}