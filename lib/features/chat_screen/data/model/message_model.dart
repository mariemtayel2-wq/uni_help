import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uni_help/features/chat_screen/domain/entities/message_entity.dart';


class MessageModel {
  const MessageModel({required this.id, required this.text, required this.senderId, required this.createdAt});

  final String id;
  final String text;
  final String senderId;
  final DateTime createdAt;

  factory MessageModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return MessageModel(
      id: doc.id,
      text: data['text'] as String? ?? '',
      senderId: data['senderId'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  static Map<String, dynamic> toMap({required String senderId, required String text}) {
    return {'text': text, 'senderId': senderId, 'createdAt': FieldValue.serverTimestamp()};
  }

  MessageEntity toEntity() => MessageEntity(id: id, text: text, senderId: senderId, createdAt: createdAt);
}