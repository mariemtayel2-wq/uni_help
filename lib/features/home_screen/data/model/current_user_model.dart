import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:uni_help/features/home_screen/domain/entity/current_user_entity.dart';

class CurrentUserModel {
  const CurrentUserModel({required this.fullName});

  final String fullName;

  factory CurrentUserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return CurrentUserModel(fullName: data['fullName'] as String? ?? '');
  }

  CurrentUserEntity toEntity() => CurrentUserEntity.fromFullName(fullName);
}