import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/core/services/cloudinary_service.dart';
import 'package:uni_help/features/create_request/data/model/create_request_dto.dart';
import 'package:uni_help/features/create_request/domain/repo/request_data_source.dart';

@LazySingleton(as: CreateRequestRemoteDataSource)
class CreateRequestRemoteDataSourceImpl
    implements CreateRequestRemoteDataSource {
  final FirebaseFirestore firestore;
  final CloudinaryService cloudinaryService;

  CreateRequestRemoteDataSourceImpl({
    required this.firestore,
    required this.cloudinaryService,
  });

  @override
  Future<void> createRequest(
    CreateRequestModel requestModel,
    File? attachment,
  ) async {
    try {
      String? attachmentUrl;

      if (attachment != null) {
        attachmentUrl = await cloudinaryService.uploadFile(
          attachment,
        );
      }

      final finalModel = CreateRequestModel.fromEntity(
        requestModel.toEntity(),
        attachmentUrl: attachmentUrl,
      );

      final user = FirebaseAuth.instance.currentUser;
      final userSnapshot = user == null
          ? null
          : await firestore.collection('users').doc(user.uid).get();
      final userData = userSnapshot?.data() ?? const <String, dynamic>{};
      final requesterName = (userData['fullName'] as String?)?.trim().isNotEmpty == true
          ? (userData['fullName'] as String).trim()
          : user?.displayName?.trim();
      final nameParts = requesterName?.split(RegExp(r'\s+')) ?? const <String>[];
      final requesterInitials = nameParts.isEmpty
          ? '?'
          : nameParts.take(2).map((part) => part[0].toUpperCase()).join();

      final requestData = finalModel.toJson();
      requestData['requesterName'] = requesterName?.isNotEmpty == true ? requesterName : 'Unknown';
      requestData['requesterInitials'] = requesterInitials;
      requestData['requesterRating'] = (userData['rating'] as num?)?.toDouble() ?? 0;
      requestData['requesterRatingCount'] = (userData['ratingCount'] as num?)?.toInt() ?? 0;

      await firestore.collection('requests').add(
        requestData,
      );
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }
}