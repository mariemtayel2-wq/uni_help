import 'package:uni_help/features/chat_screen/domain/entities/message_entity.dart';

abstract class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  const ChatLoaded({required this.chatId, required this.messages, this.isSending = false});

  final String chatId;
  final List<MessageEntity> messages;
  final bool isSending;

  ChatLoaded copyWith({List<MessageEntity>? messages, bool? isSending}) {
    return ChatLoaded(
      chatId: chatId,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }
}

class ChatError extends ChatState {
  const ChatError(this.message);

  final String message;
}