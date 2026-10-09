import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_help/features/chat_screen/data/model/chat_summary_model.dart';
import 'package:uni_help/features/chat_screen/data/model/message_model.dart';
import 'package:uni_help/features/chat_screen/domain/repo/chat_data_source.dart';
import 'package:uni_help/features/notification_screen/domain/enums/notification_type.dart';
import 'package:uni_help/features/notification_screen/domain/use_case/send_notification_use_case.dart';

@LazySingleton(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ChatRemoteDataSourceImpl(this._sendNotification);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SendNotificationUseCase _sendNotification;

  static const _chatsCollection = 'chats';
  static const _messagesSubcollection = 'messages';
  static const _usersCollection = 'users';

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
    required String applicantId,
  }) async {
    try {
      final currentUserId = _currentUserId;

      // لازم المستخدم الحالي يبقى واحد من طرفين الشات.
      if (currentUserId != requesterId && currentUserId != applicantId) {
        throw Exception('Current user is not a participant of this chat');
      }

      // نفس الـ chatId بغض النظر مين اللي فتح الشات.
      final chatId = '${requestId}_$applicantId';

      final chatDoc = _firestore.collection(_chatsCollection).doc(chatId);
      final snapshot = await chatDoc.get();

      if (!snapshot.exists) {
        await chatDoc.set({
          'requestId': requestId,
          'requesterId': requesterId,
          'applicantId': applicantId,
          'participants': [requesterId, applicantId],
          'createdAt': FieldValue.serverTimestamp(),
          'lastMessage': '',
          'lastMessageAt': FieldValue.serverTimestamp(),
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
        // عشان نعرف لما الرسالة تتأكد من السيرفر (hasPendingWrites بتتغير).
        .snapshots(includeMetadataChanges: true)
        .map(
          (snapshot) => snapshot.docs.map(MessageModel.fromSnapshot).toList(),
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

      final chatRef = _firestore.collection(_chatsCollection).doc(chatId);
      final chatSnapshot = await chatRef.get();
      final chatData = chatSnapshot.data();
      if (!chatSnapshot.exists || chatData == null) {
        throw Exception('Conversation not found');
      }

      final participants = List<String>.from(
        chatData['participants'] as List? ?? const <String>[],
      );
      if (!participants.contains(currentUserId) || participants.length != 2) {
        throw Exception('Current user is not a participant of this chat');
      }

      final recipientId = participants.firstWhere((id) => id != currentUserId);
      final messageRef = chatRef.collection(_messagesSubcollection).doc();

      // الرسالة وآخر رسالة في الشات بيتكتبوا مع بعض أو مفيش.
      final batch = _firestore.batch();
      batch.set(
        messageRef,
        MessageModel.toMap(senderId: currentUserId, text: text),
      );
      batch.update(chatRef, {
        'lastMessage': text,
        'lastMessageAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      try {
        final senderSnapshot = await _firestore
            .collection(_usersCollection)
            .doc(currentUserId)
            .get();
        final senderName =
            senderSnapshot.data()?['fullName'] as String? ??
            _firebaseAuth.currentUser?.displayName ??
            'New message';

        await _sendNotification(
          targetUid: recipientId,
          type: NotificationType.chatMessage,
          title: senderName,
          body: text,
          senderId: currentUserId,
          senderName: senderName,
          chatId: chatId,
          notificationId: messageRef.id,
        );
      } catch (e) {
        debugPrint('Chat message notification failed: $e');
      }
    } on FirebaseException catch (e) {
      throw Exception('Failed to send message: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception('Unexpected error while sending message: $e');
    }
  }

  @override
  Stream<List<ChatSummaryModel>> watchMyChats() {
    // محتاج Composite Index: participants (Array contains) + lastMessageAt (Descending).
    return _firestore
        .collection(_chatsCollection)
        .where('participants', arrayContains: _currentUserId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(ChatSummaryModel.fromSnapshot).toList(),
        )
        .handleError((Object e) {
          if (e is FirebaseException) {
            throw Exception('Failed to load chats: ${e.message ?? e.code}');
          }
          throw Exception('Unexpected error while loading chats: $e');
        });
  }

  @override
  Future<String> getUserName(String userId) async {
    try {
      final normalizedUserId = userId.trim();
      if (normalizedUserId.isEmpty) {
        return '';
      }

      final doc = await _firestore
          .collection(_usersCollection)
          .doc(normalizedUserId)
          .get();
      return doc.data()?['fullName'] as String? ?? '';
    } on FirebaseException catch (e) {
      throw Exception('Failed to load user: ${e.message ?? e.code}');
    } catch (e) {
      throw Exception('Unexpected error while loading user: $e');
    }
  }
}
