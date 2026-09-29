import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/features/chat_screen/data/model/message_model.dart';
import 'package:uni_help/features/chat_screen/domain/repo/chat_data_source.dart';

@LazySingleton(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const _chatsCollection = 'chats';
  static const _messagesSubcollection = 'messages';

  String get _currentUserId {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid == null) {
      throw Exception('No account is currently signed in');
    }
    return uid;
  }

  @override
  Future<String> getOrCreateChat({
    required String requestId,
    required String requesterId,
  }) async {
    try {
      final currentUserId = _currentUserId;
      final chatId = '${requestId}_$currentUserId';

      final chatDoc = _firestore.collection(_chatsCollection).doc(chatId);
      final snapshot = await chatDoc.get();

      if (!snapshot.exists) {
        await chatDoc.set({
          'requestId': requestId,
          'participants': [requesterId, currentUserId],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return chatId;
    } on FirebaseException catch (e) {
      throw Exception('Failed to get or create chat: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception('Unexpected error while getting or creating chat: $e');
    }
  }

  @override
  Stream<List<MessageModel>> watchMessages(String chatId) {
    return _firestore
        .collection(_chatsCollection)
        .doc(chatId)
        .collection(_messagesSubcollection)
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(MessageModel.fromSnapshot).toList(),
        )
        .handleError((Object e) {
      if (e is FirebaseException) {
        throw Exception('Failed to load messages: ${e.message ?? e.code}');
      }
      throw Exception('Unexpected error while loading messages: $e');
    });
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    try {
      final currentUserId = _currentUserId;

      await _firestore
          .collection(_chatsCollection)
          .doc(chatId)
          .collection(_messagesSubcollection)
          .add(MessageModel.toMap(senderId: currentUserId, text: text));
    } on FirebaseException catch (e) {
      throw Exception('Failed to send message: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception('Unexpected error while sending message: $e');
    }
  }
}