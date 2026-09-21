import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@lazySingleton
class CloudinaryService {
  final String cloudName = 'ut7zxnpj';
  final String uploadPreset = 'uni_help_upload';

  Future<String> uploadFile(File file) async {
    try {
      if (!await file.exists()) {
        throw Exception('Selected file does not exist: ${file.path}');
      }

      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/auto/upload',
      );

      final request = http.MultipartRequest('POST', uri);

      request.fields['upload_preset'] = uploadPreset;

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
        ),
      );

      final response = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        if (response.statusCode == 401) {
          throw Exception(
            'Cloudinary rejected the upload credentials. '
            'The upload preset must be configured as unsigned.',
          );
        }
        throw Exception(
          'Cloudinary upload failed (${response.statusCode}): $responseBody',
        );
      }

      final data = jsonDecode(responseBody);

      return data['secure_url'] as String;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }
}