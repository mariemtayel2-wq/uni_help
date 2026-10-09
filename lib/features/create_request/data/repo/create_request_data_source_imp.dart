import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/core/model/request_dto.dart';
import 'package:uni_help/core/services/cloudinary_service.dart';
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
  Future<String> createRequest(
    RequestModel requestModel,
    File? attachment,
  ) async {
    try {
      String? attachmentUrl;

      if (attachment != null) {
        attachmentUrl = await cloudinaryService.uploadFile(
          attachment,
        );
      }

      final finalModel = RequestModel.fromEntity(
        requestModel.toEntity(),
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

      final requestData = finalModel.toMap();
      requestData['requesterName'] = requesterName?.isNotEmpty == true ? requesterName : 'Unknown';
      requestData['requesterInitials'] = requesterInitials;
      requestData['requesterRating'] = (userData['rating'] as num?)?.toDouble() ?? 0;
      requestData['requesterRatingCount'] = (userData['ratingCount'] as num?)?.toInt() ?? 0;

      // ============================================================
      // من هنا لتحت: توفيق أسماء/أشكال الحقول مع اللي Home وExplore
      // وfirestore.rules بيتوقعوها. من غير الجزء ده، الطلب هيترفض
      // إنشاءه من الأساس (rules بتتأكد من requesterId مش userId)،
      // ولو افترضنا اتعدلت الـ rules، الطلب هيظهر في Home بلا تاجات
      // ولا مرفقات ولا وقت مفضّل.
      // ============================================================

      // requesterId مش userId
      requestData['requesterId'] = user?.uid ?? '';
      requestData.remove('userId');

      // tags (List) بدل skillNeeded (String) بس — الأصل لسه موجود لو
      // حبيتي تستخدميه في مكان تاني.
      final skill = requestData['skillNeeded'] as String?;
      requestData['tags'] = (skill == null || skill.isEmpty) ? <String>[] : [skill];

      // attachments (List) بدل attachmentUrl (String) بس
      requestData['attachments'] = attachmentUrl != null ? [attachmentUrl] : <String>[];

      // preferredTime كـ String مقروء، مش Timestamp — Home بتتوقعه نص
      final preferredTimeValue = requestData['preferredTime'];
      if (preferredTimeValue is Timestamp) {
        requestData['preferredTime'] = _formatPreferredTime(preferredTimeValue.toDate());
      }

      final requestRef = await firestore.collection('requests').add(
        requestData,
      );
      return requestRef.id;
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  String _formatPreferredTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '${dateTime.day}/${dateTime.month}, $hour:$minute $period';
  }

// Future<CreateRequestModel> getRequestById(String requestId) async {
//   try {
//     final doc = await firestore.collection('requests').doc(requestId).get();

//     if (!doc.exists || doc.data() == null) {
//       throw Exception('Request not found');
//     }

//     // إرسال الـ Map كأول Parameter والـ docId كـ Named Parameter
//     return CreateRequestModel.fromMap(
//       doc.data()!,
//       docId: doc.id,
//     );
//   } catch (e) {
//     throw Exception('Failed to fetch request details: ${e.toString()}');
//   }
// }
}